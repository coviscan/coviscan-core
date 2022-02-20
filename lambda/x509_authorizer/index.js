const AWS      = require('aws-sdk');
const Config   = require('./config.js');
const forge    = require('node-forge');
const {sha256} = require('crypto-hash');

exports.handler = async (event)=> {
  console.log("Incoming event- ", JSON.stringify(event));
  if ( event && event.requestContext.identity.clientCert ) {
    const pemContent = event.requestContext.identity.clientCert.clientCertPem;

    try {
      // Parse certificate and create a hashed identifier
      const cert = forge.pki.certificateFromPem(pemContent);
      let iss    = cert.issuer.getField('CN').value.trim();
      let sub    = cert.subject.getField('CN').value.trim();

      if ( iss !== null && iss == "free" ) {
        let policy = generate_iam_policy(sub, "free_key_r1hu21cfpuruk5kk1vip1scb8esh5r");
        console.log("IAM Policy- ", JSON.stringify(policy));
        return policy;
      } else if ( iss !== null && iss == "enterprise" ) {
        let policy = generate_iam_policy(sub, "enterprise_key_gvy52b7lmzd10led2l781bk8wdb8wj");
        console.log("IAM Policy- ", JSON.stringify(policy));
        return policy;
      } else {
        console.error("No permissions");
        return generate_deny_all_iam_policy(sub);
      }
    }
    catch(err) {
        console.error("Unable to authorize- ", err);
        return generate_deny_all_iam_policy();
    }
  }
  else{
    console.error("Client certificate is not present in the request");
    return generate_deny_all_iam_policy();
  }
};

function generate_iam_policy(principal, usagePlanApiKey){
  return {
    "principalId": (principal ? principal:'subject'),
    "policyDocument": {
      "Version":"2012-10-17",
      "Statement": [
        {
          "Action":"execute-api:Invoke",
          "Effect":"Allow",
          "Resource":"*"
        }
      ]
    },
    "usageIdentifierKey": usagePlanApiKey
  };
}

function generate_deny_all_iam_policy(principal){
  return {
    "principalId": (principal ? principal:'subject'),
    "policyDocument": {
      "Version":"2012-10-17",
      "Statement": [
        {
          "Action":"execute-api:Invoke",
          "Effect":"Deny",
          "Resource":"*"
        }
      ]
    }
  };
}