let source = [];
let result = [];
const endpoint = "./js/datum-measles.json";
const ingest = function (info,callback) {
  fetch(endpoint,{
    method:"GET",
    headers:{"Content-Type":"application/json"}
  })
  .then(response => response.json())
  .then(parse => store(parse))
  .catch(function(error) {
    // console.error(error);
  })
  .finally(function () {
        if (!!callback && callback instanceof Function) {
          callback();
        }
      }
  );
};

let Admin1 = ["Alaska","Alabama","Arkansas","Arizona","California","Colorado","Connecticut","District of Columbia","Delaware","Florida","Georgia","Hawaii","Iowa","Idaho","Illinois","Indiana","Kansas","Kentucky","Louisiana","Massachusetts","Maryland","Maine","Michigan","Minnesota","Missouri","Mississippi","Montana","North Carolina","North Dakota","Nebraska","New Hampshire","New Jersey","New Mexico","Nevada","New York","Ohio","Oklahoma","Oregon","Pennsylvania","Rhode Island","South Carolina","South Dakota","Tennessee","Texas","Utah","Virginia","Vermont","Washington","Wisconsin","West Virginia","Wyoming"];
let Admin2 = [["ALASKA","AK"],["ALABAMA","AL"],["ARKANSAS","AR"],["ARIZONA","AZ"],["CALIFORNIA","CA"],["COLORADO","CO"],["CONNECTICUT","CT"],["DISTRICT OF COLUMBIA","DC"],["DELAWARE","DE"],["FLORIDA","FL"],["GEORGIA","GA"],["HAWAII","HI"],["IOWA","IA"],["IDAHO","ID"],["ILLINOIS","IL"],["INDIANA","IN"],["KANSAS","KS"],["KENTUCKY","KY"],["LOUISIANA","LA"],["MASSACHUSETTS","MA"],["MARYLAND","MD"],["MAINE","ME"],["MICHIGAN","MI"],["MINNESOTA","MN"],["MISSOURI","MO"],["MISSISSIPPI","MS"],["MONTANA","MT"],["NORTH CAROLINA","NC"],["NORTH DAKOTA","ND"],["NEBRASKA","NE"],["NEW HAMPSHIRE","NH"],["NEW JERSEY","NJ"],["NEW MEXICO","NM"],["NEVADA","NV"],["NEW YORK","NY"],["OHIO","OH"],["OKLAHOMA","OK"],["OREGON","OR"],["PENNSYLVANIA","PA"],["RHODE ISLAND","RI"],["SOUTH CAROLINA","SC"],["SOUTH DAKOTA","SD"],["TENNESSEE","TN"],["TEXAS","TX"],["UTAH","UT"],["VERMONT","VT"],["VIRGINIA","VA"],["WASHINGTON","WA"],["WISCONSIN","WI"],["WEST VIRGINIA","WV"],["WYOMING","WY"]];
let Admin3 = [["ALABAMA","AL"],["ALASKA","AK"],["ARIZONA","AZ"],["ARKANSAS","AR"],["CALIFORNIA","CA"],["COLORADO","CO"],["CONNECTICUT","CT"],["DELAWARE","DE"],["DISTRICT OF COLUMBIA","DC"],["FLORIDA","FL"],["GEORGIA","GA"],["HAWAII","HI"],["IDAHO","ID"],["ILLINOIS","IL"],["INDIANA","IN"],["IOWA","IA"],["KANSAS","KS"],["KENTUCKY","KY"],["LOUISIANA","LA"],["MAINE","ME"],["MARYLAND","MD"],["MASSACHUSETTS","MA"],["MICHIGAN","MI"],["MINNESOTA","MN"],["MISSISSIPPI","MS"],["MISSOURI","MO"],["MONTANA","MT"],["NEBRASKA","NE"],["NEVADA","NV"],["NEW HAMPSHIRE","NH"],["NEW JERSEY","NJ"],["NEW MEXICO","NM"],["NEW YORK","NY"],["NORTH CAROLINA","NC"],["NORTH DAKOTA","ND"],["OHIO","OH"],["OKLAHOMA","OK"],["OREGON","OR"],["PENNSYLVANIA","PA"],["RHODE ISLAND","RI"],["SOUTH CAROLINA","SC"],["SOUTH DAKOTA","SD"],["TENNESSEE","TN"],["TEXAS","TX"],["UTAH","UT"],["VERMONT","VT"],["VIRGINIA","VA"],["WASHINGTON","WA"],["WEST VIRGINIA","WV"],["WISCONSIN","WI"],["WYOMING","WY"]];

const store = function (parse) {
  source = parse[0].data.values.data;
  source.forEach((val,i,a) => {
    result[i] = (val.concat(Admin2[val[1]])).toString();
  });
};

window.calc = function () {


  return {

    loadData: function () { ingest(); },
    getData: function () { return result; }
  }

}();