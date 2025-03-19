const businessTypes = [
    'Food and Beverage',
    'abc',
    'Retail and Shopping',
    'Health and Wellness',
    'Entertainment and Leisure',
    'Hospitality and Travel',
    'Personal Services',
    'Education and Learning',
    'Events and Experience',
    'Automotive and Transportation'
  ];
  
  // Fetch all business types
  const getBusinessTypes = (req, res) => {
    res.json({ businessTypes });
  };
  
  module.exports = {
    getBusinessTypes,
  };