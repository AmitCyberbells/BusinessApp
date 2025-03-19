const express = require("express");
const cors = require("cors");

const app = express();
const PORT = 5001;

app.use(cors()); // Enable CORS for all origins
app.use(express.json()); // Middleware to parse JSON

// Mock business types API
app.get("/business-types", (req, res) => {
  const businessTypes = [
    "Food and Beverage",
    'abc',  
    "Retail and Shopping",
    "Health and Wellness",
    "Entertainment and Leisure",
    "Hospitality and Travel",
    "Personal Services",
    "Education and Learning",
    "Events and Experience",
    "Automotive and Transportation",
  ];
  
  res.json(businessTypes);
});

app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});
