import { generate } from "./events/generate";

exports.handler = async() => {
  console.log("Job started");
  // const result = generate();
  // console.log(result);
  console.log("Job ended");
  // return result;
  return ('hi');
}
