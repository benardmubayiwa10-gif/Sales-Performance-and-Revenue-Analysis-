# Electric Vehicle Sales Dashboard

An interactive data visualization dashboard for analyzing electric vehicle sales performance, revenue trends, and customer insights.

## Overview

This dashboard provides comprehensive analytics based on EV sales data including revenue trends, regional performance, unit sales, and customer sentiment analysis. Built with React and Recharts for dynamic, real-time data visualization.

## Features

### Key Performance Indicators (KPIs)
- **Total Revenue** - Aggregate revenue across all transactions
- **Total Units Sold** - Complete vehicle unit count
- **Average Revenue** - Mean revenue per transaction
- **Average Units** - Mean units per transaction

### Interactive Visualizations
1. **Monthly Revenue Trend** - Line chart showing revenue patterns over time
2. **Revenue by Region** - Bar chart comparing performance across geographic regions
3. **Units vs Revenue Correlation** - Scatter plot analyzing the relationship between units sold and revenue
4. **Customer Sentiment** - Pie chart displaying positive, neutral, and negative feedback distribution
5. **Monthly Units Sold** - Bar chart tracking unit sales over time

### Filter Capabilities
- Region-based filtering (North, South, East, West, All)
- Dynamic data updates based on selected filters

## Technologies Used

- **React** - Frontend framework
- **Recharts** - Chart library for data visualization
- **Lucide React** - Icon library
- **Tailwind CSS** - Styling framework

## Data Structure

The dashboard expects data with the following fields:
```javascript
{
  date: "2023-01-01",
  month: "Jan",
  region: "North",
  unitsSold: 120,
  revenue: 5400000,
  sentiment: "Positive"
}
```

## Setup Instructions

### Prerequisites
- Node.js (v14 or higher)
- npm or yarn

### Installation

1. **Install dependencies:**
   ```bash
   npm install react recharts lucide-react
   ```

2. **Run the dashboard:**
   ```bash
   npm start
   ```

3. **Access the dashboard:**
   Open your browser to `http://localhost:3000`

## Connecting Your Data

### Using Real CSV Data

Replace the `generateSampleData()` function with your actual data loading logic:

```javascript
// Option 1: Load from CSV file
import Papa from 'papaparse';

const loadData = async () => {
  const response = await fetch('/path/to/Electric_vehicle_sales.csv');
  const csvText = await response.text();
  
  Papa.parse(csvText, {
    header: true,
    complete: (results) => {
      const processedData = results.data.map(row => ({
        date: row.Date,
        month: new Date(row.Date).toLocaleString('en', { month: 'short' }),
        region: row.Region,
        unitsSold: parseInt(row.Units_Sold),
        revenue: parseFloat(row.Revenue),
        sentiment: row.Sentiment || 'Neutral'
      }));
      setData(processedData);
    }
  });
};
```

### Using API Endpoint

```javascript
const loadData = async () => {
  const response = await fetch('https://your-api.com/ev-sales');
  const jsonData = await response.json();
  setData(jsonData);
};
```

## Customization

### Changing Colors
Modify the `COLORS` and `SENTIMENT_COLORS` constants:
```javascript
const COLORS = ['#10b981', '#3b82f6', '#f59e0b', '#ef4444'];
const SENTIMENT_COLORS = { 
  Positive: '#10b981', 
  Neutral: '#f59e0b', 
  Negative: '#ef4444' 
};
```

### Adding New Regions
Update the `regions` array:
```javascript
const regions = ['All', 'North', 'South', 'East', 'West', 'Central', 'International'];
```

### Modifying Chart Heights
Adjust the `height` prop in ResponsiveContainer:
```javascript
<ResponsiveContainer width="100%" height={400}>
```

## Analysis Capabilities

Based on the R script analysis, this dashboard supports:
- Descriptive statistics visualization
- Revenue distribution analysis
- Regional performance comparison
- Time series trend analysis
- Correlation analysis (Units vs Revenue)
- Customer sentiment tracking
- KPI monitoring

## Performance Considerations

- Data is memoized using `useMemo` to prevent unnecessary recalculations
- Charts are responsive and optimized for different screen sizes
- Filter operations are efficient and update instantly

## Deployment

### Build for Production
```bash
npm run build
```

### Deploy to Vercel
```bash
vercel deploy
```

### Deploy to Netlify
```bash
netlify deploy --prod
```

## Browser Support

- Chrome (recommended)
- Firefox
- Safari
- Edge

## Troubleshooting

### Charts not rendering
- Ensure all dependencies are installed
- Check that data structure matches expected format
- Verify ResponsiveContainer has a parent with defined height

### Data not loading
- Check CSV file path
- Verify data format matches expected structure
- Look for console errors

### Filters not working
- Ensure region names match exactly (case-sensitive)
- Check that setSelectedRegion is properly connected

## Future Enhancements

- Export data to PDF/Excel
- Date range filtering
- Predictive analytics integration
- Real-time data updates via WebSocket
- Advanced filtering (multi-select, date ranges)
- Custom dashboard layouts
- User authentication
- Data export capabilities

## License

MIT License - feel free to use and modify for your projects

## Support

For questions or issues, please contact your development team or submit an issue in the project repository.

## Acknowledgments

Based on the comprehensive R script analysis covering:
- Linear regression modeling
- ARIMA forecasting
- Random Forest predictions
- Customer clustering
- Survival analysis
- Monte Carlo simulations

---

**Last Updated:** February 2026  
**Version:** 1.0.0
