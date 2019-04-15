RSpec.describe DataSense do
  it "has a version number" do
    expect(DataSense::VERSION).not_to be nil
  end

  it "successfully parses a get request" do
    subscription_key = SecureRandom.hex
    api = DataSense::Api.new(subscription_key: subscription_key)
    stub_request(:get, "https://externalapi.datasense.com/api/oneroster/v1p1/schools")
      .with(headers: { "Ocp-Apim-Subscription-Key" => subscription_key })
      .to_return(status: 200, body: schools_json)
    response = api.get("/schools")
    expect(response).to eq(JSON.parse(schools_json))
  end
end

def schools_json
  {
    "schools": [{
      "name": "Graduated Students",
      "type": "school",
      "identifier": "999999",
      "parent": {
        "href": "/api/oneroster/v1p1/orgs/efa625be-ee2b-4e40-9181-b408ada8f60c",
        "sourcedId": "efa625be-ee2b-4e40-9181-b408ada8f60c",
        "type": "org"
      },
      "children": nil,
      "sourcedId": "03dd721a-b29d-48ca-a692-9dd7020177ee",
      "status": "active",
      "dateLastModified": "2018-08-03T13:29:51.81Z",
      "metadata": {}
    }, {
      "name": "Tongue River High School",
      "type": "school",
      "identifier": "1701056",
      "parent": {
        "href": "/api/oneroster/v1p1/orgs/efa625be-ee2b-4e40-9181-b408ada8f60c",
        "sourcedId": "efa625be-ee2b-4e40-9181-b408ada8f60c",
        "type": "org"
      },
      "children": nil,
      "sourcedId": "e549ab4b-47b9-4a15-85f3-a4f00166032b",
      "status": "active",
      "dateLastModified": "2017-07-05T15:26:04.35Z",
      "metadata": {}
    }],
    "statusInfoSet": [{
      "imsx_codeMajor": "success",
      "imsx_severity": "status",
      "imsx_description": "",
      "imsx_codeMinor": "full success"
    }]
  }.to_json
end
