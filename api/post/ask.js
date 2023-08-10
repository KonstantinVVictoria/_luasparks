const fetch = require("node-fetch");
const OpenAI = require("../../lib/OpenAI");
const ShovelsAPI = require("../../lib/ShovelsAPI");
require("dotenv").config();

const context = {
  role: "system",
  content: ShovelsAPI.shovels_api_info,
};
const JSON_LENGTH_LIMIT = 400; //characters
module.exports = async function ask(request, response) {
  const query = request.body.query;
  const user_input = query[query.length - 1].content;
  console.log(query);
  const question = {
    role: "user",
    content: user_input,
  };

  query.unshift(context);
  query[query.length - 1].content += ShovelsAPI.OpenAIformat;

  let data = await OpenAI.query(
    JSON.stringify({
      model: "gpt-4",
      messages: query,
      temperature: 0.2,
    })
  );
  console.log(data);
  try {
    data = JSON.parse(data);
  } catch (error) {
    return response.send({
      message: data,
    });
  }

  let shovels_api_endpoint = data[0];
  console.log(shovels_api_endpoint);
  let api_model = ShovelsAPI.Model(shovels_api_endpoint);
  console.log(api_model);
  if (api_model.message)
    return response.send({
      message: api_model.message,
    });

  let api_data = await ShovelsAPI.query(shovels_api_endpoint);
  //console.log(api_data);
  let result = api_model(api_data);
  return response.send([
    {
      role: "user",
      content:
        "JSON results from API:\n" +
        JSON.stringify(api_data).substring(0, JSON_LENGTH_LIMIT),
    },
    {
      role: "assistant",
      content: result,
    },
  ]);
  // let result = await OpenAI.query(
  //   JSON.stringify({
  //     model: "gpt-4",
  //     messages: [
  //       question,
  //       {
  //         role: "user",
  //         content:
  //           "JSON results from API:\n" +
  //           JSON.stringify(api_data).substring(0, JSON_LENGTH_LIMIT) +
  //           "\nAnswer the query given the JSON results in a conversational matter. Do not mention JSON results. If there are no results, do not not refer the user to other sites. Do not mention anything about the JSON string nor strict conditions.",
  //       },
  //     ],
  //   })
  // );
  // console.log(result);

  // response.send([
  //   {
  //     role: "user",
  //     content:
  //       "JSON results from API:\n" +
  //       JSON.stringify(api_data).substring(0, JSON_LENGTH_LIMIT),
  //   },
  //   {
  //     role: "assistant",
  //     content: result,
  //   },
  // ]);
};
