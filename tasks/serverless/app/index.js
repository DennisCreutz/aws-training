'use strict';

const axios = require('axios');

const BASE_URL = 'https://www.tronalddump.io';
const PATH = '/search/quote';

exports.handler = async (event) => {
  console.log('Event: %s', JSON.stringify(event));

  try {
    const query = event?.queryStringParameters?.query;

    console.log(query);
    if (!query) {
      throw new Error('Query not defined!');
    }

    const response = await axios.get(`${BASE_URL}${PATH}?query=${query}`);
    const quotes = response?.data?._embedded?.quotes;
    const quotesStr = JSON.stringify(quotes);
    console.log('Quotes: %s', quotesStr);

    return {
      statusCode: 200,
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
      },
      body: quotesStr ? quotesStr : JSON.stringify([]),
    };
  } catch (e) {
    console.error(e);
    return {
      statusCode: 500,
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
      },
      body: JSON.stringify(e.message)
    };
  }
};
