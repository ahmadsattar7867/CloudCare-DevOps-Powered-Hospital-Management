const request = require('supertest');
const app = require('../app');

describe('GET /', () => {
  it('responds with json', async () => {
    const response = await request(app)
      .get('/')
      .expect('Content-Type', /json/)
      .expect(200);
    
    expect(response.body).toEqual({ message: 'Hello from the backend!' });
  });
});