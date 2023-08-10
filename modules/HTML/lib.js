function component_from_template(template_id, key) {
  const component_id = template_id;
  const id = component_id + "_" + key;
  const Template = document.getElementById(template_id);
  const Component = Template.cloneNode(true);
  Component.id = id;
  return Component;
}
