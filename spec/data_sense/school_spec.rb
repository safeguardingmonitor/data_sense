RSpec.describe DataSense::School do
  let(:fake_api) { instance_double(DataSense::Api) }
  subject(:schools) { described_class.new(api: fake_api) }

  it "returns all schools" do
    allow(fake_api).to receive(:get).with("/schools").and_return(multiple_schools)
    expect(schools.all).to eq(multiple_schools["schools"])
  end

  it "returns one school" do
    school_uuid = "03dd721a-b29d-48ca-a692-9dd7020177ee"
    allow(fake_api).to receive(:get).with("/schools/#{school_uuid}").and_return(single_school)
    expect(schools.get(uuid: school_uuid)).to eq(single_school["school"])
  end
end

def single_school
  {
    "school": {
      "name": "Graduated Students",
      "type": "school",
      "identifier": "999999",
      "parent": {
        "href": "/api/oneroster/v1p1/schools/orgs/efa625be-ee2b-4e40-9181-b408ada8f60c",
        "sourcedId": "efa625be-ee2b-4e40-9181-b408ada8f60c",
        "type": "org"
      },
      "children": nil,
      "sourcedId": "03dd721a-b29d-48ca-a692-9dd7020177ee",
      "status": "active",
      "dateLastModified": "2018-08-03T13:29:51.81Z",
      "metadata": {}
    },
    "statusInfoSet": [{
      "imsx_codeMajor": "success",
      "imsx_severity": "status",
      "imsx_description": "",
      "imsx_codeMinor": "full success"
    }]
  }
end

def multiple_schools
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
  }
end
