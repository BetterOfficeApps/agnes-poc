FROM amazon/aws-lambda-nodejs:14

# Datadog settings.
ENV DD_FLUSH_TO_LOG=true
ENV DD_LAMBDA_HANDLER=".build/app.handler"
ENV DD_TRACE_ENABLED=true

# Required for node-gyp: https://github.com/nodejs/node-gyp#on-unix
RUN yum install -y gcc-c++ make

# Install packages.
COPY app/package.json ./
RUN npm install

# Build application.
COPY app .
RUN npm run build

# Set Lambda function handler. The Datadog handler wraps the handler specified by DD_LAMBDA_HANDLER.
CMD [ "node_modules/datadog-lambda-js/dist/handler.handler" ]
