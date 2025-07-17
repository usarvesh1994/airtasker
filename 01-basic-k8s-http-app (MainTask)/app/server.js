const express = require('express');
const client = require('prom-client'); // Prometheus client

const app = express();

const PORT = process.env.PORT || 3000;

// Define the application name from environment variable or fallback to default
const APP_NAME = process.env.APP_NAME || 'airtasker';

// Prometheus metrics setup
const register = new client.Registry();
client.collectDefaultMetrics({ register });

const httpRequestsTotal = new client.Counter({
  name: 'http_requests_total',
  help: 'Total number of HTTP requests',
  labelNames: ['method', 'path', 'status'],
});
register.registerMetric(httpRequestsTotal);

const httpRequestDurationSeconds = new client.Histogram({
  name: 'http_request_duration_seconds',
  help: 'Duration of HTTP requests in seconds',
  labelNames: ['method', 'path', 'status'],
  buckets: [0.01, 0.05, 0.1, 0.25, 0.5, 1, 2, 5],
});
register.registerMetric(httpRequestDurationSeconds);

// Middleware to record metrics
app.use((req, res, next) => {
  const start = httpRequestDurationSeconds.startTimer({
    method: req.method,
    path: req.path,
  });

  res.on('finish', () => {
    const labels = {
      method: req.method,
      path: req.path,
      status: res.statusCode,
    };
    httpRequestsTotal.inc(labels);
    start({ status: res.statusCode });
  });

  next();
});

// Route: GET /
// Returns the value of APP_NAME with Content-Type as text/plain and status code 200
app.get('/', (req, res) => {
  res.type('text/plain').status(200).send(APP_NAME);
});

// Route: GET /healthcheck
// Returns "OK" for health check purposes with Content-Type as text/plain
app.get('/healthcheck', (req, res) => {
  res.type('text/plain').status(200).send('OK');
});

// Expose Prometheus metrics at /metrics
app.get('/metrics', async (req, res) => {
  res.set('Content-Type', register.contentType);
  res.end(await register.metrics());
});

// Catch-all for undefined routes — return 404 with plain text
app.use((req, res) => {
  res.status(404).type('text/plain').send('404 Not Found');
});

// Start the server and listen on the defined port
app.listen(PORT, () => {
  console.log(`HTTP server running on port ${PORT}`);
});
