const request = require('supertest');
const path = require('path');
const fs = require('fs');

// Create a minimal config file for testing
const configDir = path.join(__dirname, '..', 'config');
const testConfigPath = path.join(configDir, 'test.json');
if (!fs.existsSync(configDir)) {
  fs.mkdirSync(configDir, { recursive: true });
}
fs.writeFileSync(testConfigPath, JSON.stringify({
  // Add any necessary configuration for your tests
  database: {
    uri: 'mongodb://localhost:27017/test_hospital_db'
  }
}));

// Set environment variables for testing
process.env.NODE_ENV = 'test';
process.env.NODE_CONFIG_DIR = configDir;

// Now we can safely require our server
const app = require('../server');

describe('Server', () => {
  let server;

  beforeAll((done) => {
    server = app.listen(done);
  });

  afterAll((done) => {
    server.close(done);
  });

  it('responds with json at /', async () => {
    const response = await request(server)
      .get('/')
      .expect('Content-Type', /json/)
      .expect(200);
    
    expect(response.body).toEqual({ message: 'Welcome to the Hospital API' });
  });

  it('responds with 404 for unknown routes', async () => {
    await request(server)
      .get('/unknown-route')
      .expect(404);
  });

  // Add more tests for your routes
  describe('Auth routes', () => {
    it('responds to /auth/login', async () => {
      await request(server)
        .post('/auth/login')
        .send({ username: 'testuser', password: 'testpass' })
        .expect(400); // Assuming 400 for invalid credentials
    });
  });

  describe('User routes', () => {
    it('responds to /user', async () => {
      await request(server)
        .get('/user')
        .expect(401); // Assuming 401 for unauthorized access
    });
  });

  // Add similar tests for other routes (doctor, nurse, appointment, admin)
});

// Clean up the test config file
afterAll(() => {
  fs.unlinkSync(testConfigPath);
});

console.log('All tests completed.');