# Virtual Smart Meter Simulator

A Python-based virtual smart meter that simulates real-time power consumption data for computer labs and sends it to your backend for CO₂ emission monitoring.

## Features

✅ **Realistic Power Simulation**
- Voltage fluctuations (220-240V)
- Dynamic current based on lab state (idle/normal/busy/peak)
- Random spikes to simulate device on/off

✅ **Multiple Lab States**
- **Idle**: Few computers on (~2A)
- **Normal**: Half capacity (~5A)
- **Busy**: Full capacity (~8A)
- **Peak**: All devices + AC (~11A)

✅ **Real-time Metrics**
- Voltage (V)
- Current (A)
- Power (W & kWh)
- CO₂ emissions (kg)
- Cumulative totals

✅ **Live Data Streaming**
- Sends readings every 3 seconds (configurable)
- Automatic state transitions
- Connection status monitoring

## Installation

### 1. Install Python Dependencies

```bash
cd /home/hari/Desktop/pro/virtual_smart_meter
pip install -r requirements.txt
```

Or install manually:
```bash
pip install requests
```

### 2. Make Script Executable

```bash
chmod +x smart_meter_simulator.py
```

## Usage

### Basic Usage (Default Settings)

```bash
python smart_meter_simulator.py
```

This will:
- Connect to `http://localhost:5000`
- Send readings every 3 seconds
- Run continuously until Ctrl+C

### Advanced Options

```bash
# Custom interval (5 seconds)
python smart_meter_simulator.py --interval 5

# Run for specific duration (10 minutes)
python smart_meter_simulator.py --duration 10

# Custom backend URL
python smart_meter_simulator.py --backend http://192.168.1.100:5000

# Custom lab name
python smart_meter_simulator.py --lab "Computer Lab - Block B"

# Combined options
python smart_meter_simulator.py --interval 2 --duration 30 --lab "Main Lab"
```

### Help

```bash
python smart_meter_simulator.py --help
```

## Configuration

Edit the script to change default values:

```python
LAB_NAME = "Computer Lab - Block A"
BACKEND_URL = "http://localhost:5000"
INTERVAL_SECONDS = 3
DURATION_MINUTES = None  # Continuous
```

## Emission Calculation

The simulator uses standard emission factors:

- **1 kWh = 0.8 kg CO₂** (Average for India's power grid)
- **Cost**: ₹7 per kWh
- **Tree offset**: 1 tree absorbs ~21 kg CO₂/year

## Example Output

```
╔══════════════════════════════════════════════════════════════════╗
║           🔌 VIRTUAL SMART METER SIMULATOR                       ║
║           Computer Lab Energy Monitoring System                  ║
╚══════════════════════════════════════════════════════════════════╝

Lab Name: Computer Lab - Block A
Backend: http://localhost:5000
Interval: 3 seconds
Duration: Continuous

======================================================================
📊 Reading #42 | ✅ SENT
======================================================================
🏢 Lab: Computer Lab - Block A
🕐 Time: 2025-10-31T16:15:30.123456
⚡ State: busy (Full capacity)
──────────────────────────────────────────────────────────────────────
📈 Voltage:       228.45 V
📈 Current:         8.23 A
⚡ Power:        1879.94 W
💡 Energy:      0.000522 kWh
🌍 CO₂:         0.000418 kg
──────────────────────────────────────────────────────────────────────
📊 Total Energy:   0.0219 kWh
🌍 Total CO₂:      0.0175 kg

⚠️  WARNING: Approaching CO₂ limit! 18.5 kg / 20 kg (92.5%)
======================================================================
```

## Backend Integration

The simulator sends JSON data to: `POST /api/smart-meter/reading`

### Request Format

```json
{
  "lab_name": "Computer Lab - Block A",
  "timestamp": "2025-10-31T16:15:30.123456",
  "voltage": 228.45,
  "current": 8.23,
  "power_watts": 1879.94,
  "power_kwh": 0.000522,
  "co2_kg": 0.000418,
  "total_kwh": 0.0219,
  "total_co2_kg": 0.0175,
  "lab_state": "busy",
  "reading_number": 42
}
```

### Response Format

```json
{
  "success": true,
  "message": "Reading received",
  "reading_id": "507f1f77bcf86cd799439011",
  "limit_status": {
    "exceeded": false,
    "current": 18.5,
    "limit": 20,
    "percentage": 92.5,
    "timeWindow": 60
  },
  "warning": "⚠️ WARNING: Approaching CO₂ limit!",
  "alert_level": "warning"
}
```

## Troubleshooting

### Backend Not Reachable

```
❌ FAILED
⚠️ Error: Backend not reachable
```

**Solutions:**
1. Make sure backend server is running: `cd bhoomi_backend && node server.js`
2. Check backend URL is correct
3. Try: `curl http://localhost:5000/health`

### Connection Refused

```
Error: Connection refused
```

**Solutions:**
1. Backend not started
2. Wrong port number
3. Firewall blocking connection

### Import Error

```
ModuleNotFoundError: No module named 'requests'
```

**Solution:**
```bash
pip install requests
```

## Stopping the Simulator

Press `Ctrl+C` to stop. You'll see a summary:

```
╔══════════════════════════════════════════════════════════════════╗
║                    SIMULATION SUMMARY                            ║
╚══════════════════════════════════════════════════════════════════╝

Total Readings:      240
Total Energy:        0.1250 kWh
Total CO₂ Emitted:   0.1000 kg
Average Power:       1875.00 W

💰 Estimated Cost:   ₹0.88 (@ ₹7/kWh)
🌳 Trees Needed:     0.00 trees to offset
                     (1 tree absorbs ~21 kg CO₂/year)
```

## Running Multiple Labs

You can run multiple simulators for different labs:

```bash
# Terminal 1
python smart_meter_simulator.py --lab "Lab A"

# Terminal 2
python smart_meter_simulator.py --lab "Lab B"

# Terminal 3
python smart_meter_simulator.py --lab "Lab C"
```

## Next Steps

1. ✅ Start backend server
2. ✅ Run simulator
3. ⏳ Build Flutter UI to display live data
4. ⏳ Add push notifications for warnings
5. ⏳ Create dashboard with charts

## API Endpoints

Once data is flowing, you can query:

```bash
# Get latest reading
curl http://localhost:5000/api/smart-meter/latest/Computer%20Lab%20-%20Block%20A

# Get history (last hour)
curl http://localhost:5000/api/smart-meter/history/Computer%20Lab%20-%20Block%20A?hours=1

# Get hourly summary (last 24 hours)
curl http://localhost:5000/api/smart-meter/summary/Computer%20Lab%20-%20Block%20A?hours=24

# Get all labs
curl http://localhost:5000/api/smart-meter/labs
```

## License

MIT - Feel free to modify and use as needed!
