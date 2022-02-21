import http from 'k6/http';
import { sleep, check } from "k6";

export const options = {
  tlsAuth: [
    {
      domains: ['api.coviscan.io'],
      cert: open('./my_client.pem'),
      key: open('./my_client.key'),
    },
  ],
};

export default function () {
  let resp = http.get('https://api.coviscan.io/identity');
  
  let passed = check(resp, {
    "status is 200": (r) => r.status === 200
  })

  // log failed response body to see what's happening
  if (!passed) {
    console.log(resp.body);
  }
}
