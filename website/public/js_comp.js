function component_from_template(template_id, key) {
  const component_id = template_id;
  const id = component_id + "_" + key;
  const Template = document.getElementById(template_id);
  const Component = Template.cloneNode(true);
  Component.id = id;
  return Component;
}
let Views = {};
Views.zip_codes = function (data) {
  data.forEach((zip_code, i) => {
    const Component = component_from_template("zip_code_view", i);
    if (output) output.appendChild(Component);
    let Label = document.querySelector("#" + "zip_code_view_" + i + " > p");
    Label.innerText = zip_code;
  });
};

Views.contractors = function (data) {
  const MAX_NUM_ITEMS = 100;
  const VIEW_NAME = "contractors_view";
  for (let i = 0; i < MAX_NUM_ITEMS && i < data.length; i++) {
    const contractor = data[i];
    const Component = component_from_template(VIEW_NAME, i);
    if (output) output.appendChild(Component);

    const Name = document.querySelector(`#${Component.id} > h4`);
    const Contractor_ID = document.querySelector(
      `#${Component.id} > section:nth-child(2) > p`
    );
    const Phone = document.querySelector(
      `#${Component.id} > section:nth-child(3) > p`
    );
    const Email = document.querySelector(
      `#${Component.id} > section:nth-child(4) > p`
    );
    const Address = document.querySelector(
      `#${Component.id} > section:nth-child(5) > p`
    );
    const LicenseNumber = document.querySelector(
      `#${Component.id} > section:nth-child(6) > p`
    );
    Name.innerText = contractor.name || "N/A";
    Phone.innerText = contractor.phone || "N/A";
    Email.innerText = contractor.email || "N/A";
    Address.innerText =
      contractor.address && contractor.zip_code && contractor.state
        ? contractor.address +
          ", " +
          contractor.zip_code +
          ", " +
          contractor.state
        : "N/A";
    LicenseNumber.innerText = contractor.license_number || "N/A";
    Contractor_ID.innerText = contractor.id;
  }
};
Views.permits = function (data) {
  const MAX_NUM_ADDR = 100;
  const MAX_NUM_PERMITS = 100;
  const VIEW_NAME = "location_view";
  for (let i = 0; i < MAX_NUM_ADDR && i < data.length; i++) {
    const location = data[i];
    const permits = location.permits;
    const Component = component_from_template(VIEW_NAME, i);
    if (output) output.appendChild(Component);
    const Summary = document.querySelector(`#${Component.id} > summary`);
    Summary.textContent = `${location.address}`;
    const UL = document.querySelector(`#${Component.id} > ul`);
    Component.ontoggle = function () {
      if (Component.open) {
        for (let j = 0; j < MAX_NUM_PERMITS && j < permits.length; j++) {
          const permit = permits[j];
          const PermitComponent = component_from_template("permits_view", j);
          if (Component) UL.appendChild(PermitComponent);
          const Name = document.querySelector(`#${PermitComponent.id} > h4`);
          const Status = document.querySelector(
            `#${PermitComponent.id} > section:nth-child(2) > p`
          );
          const Permit_ID = document.querySelector(
            `#${PermitComponent.id} > section:nth-child(3) > p`
          );
          const Permit_Type = document.querySelector(
            `#${PermitComponent.id} > section:nth-child(4) > p`
          );
          const Contractor_ID = document.querySelector(
            `#${PermitComponent.id} > section:nth-child(5) > p`
          );
          const Property_ID = document.querySelector(
            `#${PermitComponent.id} > section:nth-child(6) > p`
          );
          const Num_of_inspections = document.querySelector(
            `#${PermitComponent.id} > section:nth-child(7) > p`
          );
          const InspectionPassRate = document.querySelector(
            `#${PermitComponent.id} > section:nth-child(8) > p`
          );
          const Location = document.querySelector(
            `#${PermitComponent.id} > section:nth-child(9) > p`
          );
          const StartDate = document.querySelector(
            `#${PermitComponent.id} > section:nth-child(10) > p`
          );
          const EndDate = document.querySelector(
            `#${PermitComponent.id} > section:nth-child(11) > p`
          );
          const Fees = document.querySelector(
            `#${PermitComponent.id} > section:nth-child(12) > p`
          );
          Name.innerText = permit.description;
          Status.innerText = permit.status;
          Permit_ID.innerText = permit.permit_id;
          Permit_Type.innerText = permit.permit_type;
          Contractor_ID.innerText = permit.contractor_id;
          Property_ID.innerText = permit.property_id;
          Num_of_inspections.innerText = permit.all_inspections;
          InspectionPassRate.innerText =
            `${permit.inspections_pass_rate * 100}%` || "N/A";
          Location.innerText = permit.jurisdiction;
          StartDate.innerText = new Date(permit.start_date).toString();
          EndDate.innerText = new Date(permit.end_date).toString();
          Fees.innerText = permit.fees;
        }
      } else {
        UL.innerHTML = "";
      }
    };
  }
};

Views.metrics = function (data) {
  const MAX_NUM_PERMITS = 100;
  const VIEW_NAME = "metrics_view";
  const metrics = data;
  const permits = metrics.permit_history;
  const Component = component_from_template(VIEW_NAME, 0);
  if (output) output.appendChild(Component);
  const BusinessName = document.querySelector(`#${Component.id} > h4`);
  BusinessName.textContent = `${metrics.business_name}`;

  const Email = document.querySelector(
    `#${Component.id} > section:nth-child(2) > p`
  );
  const PhoneNumber = document.querySelector(
    `#${Component.id} > section:nth-child(3) > p`
  );
  const Address = document.querySelector(
    `#${Component.id} > section:nth-child(4) > p`
  );
  const State = document.querySelector(
    `#${Component.id} > section:nth-child(5) > p`
  );
  const ZipCode = document.querySelector(
    `#${Component.id} > section:nth-child(6) > p`
  );
  const BusinessType = document.querySelector(
    `#${Component.id} > section:nth-child(7) > p`
  );
  const LicenseNumber = document.querySelector(
    `#${Component.id} > section:nth-child(8) > p`
  );
  const Count = document.querySelector(
    `#${Component.id} > section:nth-child(9) > p`
  );
  const PassRate = document.querySelector(
    `#${Component.id} > section:nth-child(10) > p`
  );
  BusinessName.innerText = metrics.business_name || metrics.name;
  Email.innerText = metrics.email;
  PhoneNumber.innerText = metrics.phone;
  Address.innerText = metrics.address;
  State.innerText = metrics.state;
  ZipCode.innerText = metrics.zip_code;
  BusinessType.innerText = metrics.business_type;
  LicenseNumber.innerText = metrics.license_number;
  Count.innerText = metrics.count;
  PassRate.innerText = `${Math.round(metrics.pass_rate * 100)}%`;

  Component.ontoggle = function () {
    if (Component.open) {
    } else {
      UL.innerHTML = "";
    }
  };
};
