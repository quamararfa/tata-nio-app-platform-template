import { Handler } from 'aws-lambda';

const handler : Handler = async (event) => {

  console.log("request:", JSON.stringify(event, undefined, 2));


  return {
  statusCode: 500,
  headers: { "Content-Type": "text/plain" },
  body: `Hello, CDK! You've hit dummy api \n`
  };

};

// Use this due to bug https://github.com/aws-observability/aws-otel-lambda/issues/99
module.exports = { handler }