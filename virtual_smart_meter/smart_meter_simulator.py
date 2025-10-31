#!/usr/bin/env python3
"""
Virtual Smart Meter Simulator for Computer Lab
Simulates realistic power consumption and sends live data to backend
"""

import json
import time
import random
import requests
from datetime import datetime
import math

class SmartMeterSimulator:
    def __init__(self, lab_name="Computer Lab", backend_url="http://localhost:5000"):
        self.lab_name = lab_name
        self.backend_url = backend_url
        self.base_voltage = 230  # Base voltage (230V in India)
        self.base_current = 2.0  # Base current when lab is idle
        self.running = False
        
        # Simulate different lab states
        self.lab_states = {
            'idle': {'current_multiplier': 1.0, 'description': 'Few computers on'},
            'normal': {'current_multiplier': 2.5, 'description': 'Half capacity'},
            'busy': {'current_multiplier': 4.0, 'description': 'Full capacity'},
            'peak': {'current_multiplier': 5.5, 'description': 'All devices + AC'}
        }
        
        self.current_state = 'normal'
        self.total_kwh = 0.0
        self.reading_count = 0
        
    def get_realistic_voltage(self):
        """Simulate realistic voltage fluctuations (220-240V)"""
        fluctuation = random.uniform(-10, 10)
        return round(self.base_voltage + fluctuation, 2)
    
    def get_realistic_current(self):
        """Simulate realistic current based on lab state"""
        multiplier = self.lab_states[self.current_state]['current_multiplier']
        base = self.base_current * multiplier
        
        # Add random fluctuation (±20%)
        fluctuation = random.uniform(-0.2, 0.2) * base
        
        # Add some spikes (simulates device turning on/off)
        if random.random() < 0.1:  # 10% chance of spike
            fluctuation += random.uniform(1, 3)
        
        current = base + fluctuation
        return round(max(0.5, current), 2)  # Minimum 0.5A
    
    def calculate_power_kwh(self, voltage, current):
        """Calculate power consumption in kWh"""
        # Power (W) = Voltage (V) × Current (A)
        power_watts = voltage * current
        # Convert to kWh (for 1 second reading)
        power_kwh = (power_watts / 1000) / 3600  # per second
        return round(power_kwh, 6)
    
    def calculate_co2_emission(self, kwh):
        """Calculate CO2 emission from power consumption"""
        # Emission factor: 0.8 kg CO2 per kWh (average for India)
        co2_kg = kwh * 0.8
        return round(co2_kg, 6)
    
    def change_lab_state(self):
        """Randomly change lab state to simulate real usage patterns"""
        if random.random() < 0.1:  # 10% chance to change state
            states = list(self.lab_states.keys())
            self.current_state = random.choice(states)
            print(f"   → Lab state changed to: {self.current_state} ({self.lab_states[self.current_state]['description']})")
    
    def generate_reading(self):
        """Generate a single smart meter reading"""
        voltage = self.get_realistic_voltage()
        current = self.get_realistic_current()
        power_kwh = self.calculate_power_kwh(voltage, current)
        co2_kg = self.calculate_co2_emission(power_kwh)
        
        self.total_kwh += power_kwh
        self.reading_count += 1
        
        reading = {
            'lab_name': self.lab_name,
            'timestamp': datetime.now().isoformat(),
            'voltage': voltage,
            'current': current,
            'power_watts': round(voltage * current, 2),
            'power_kwh': power_kwh,
            'co2_kg': co2_kg,
            'total_kwh': round(self.total_kwh, 4),
            'total_co2_kg': round(self.total_kwh * 0.8, 4),
            'lab_state': self.current_state,
            'reading_number': self.reading_count
        }
        
        return reading
    
    def send_to_backend(self, reading):
        """Send reading to backend API"""
        try:
            response = requests.post(
                f"{self.backend_url}/api/smart-meter/reading",
                json=reading,
                timeout=5
            )
            
            if response.status_code == 200:
                result = response.json()
                return True, result
            else:
                return False, f"Error: {response.status_code}"
                
        except requests.exceptions.ConnectionError:
            return False, "Backend not reachable"
        except Exception as e:
            return False, str(e)
    
    def print_reading(self, reading, success, message):
        """Print reading in a nice format"""
        status = "✅ SENT" if success else "❌ FAILED"
        
        print(f"\n{'='*70}")
        print(f"📊 Reading #{reading['reading_number']} | {status}")
        print(f"{'='*70}")
        print(f"🏢 Lab: {reading['lab_name']}")
        print(f"🕐 Time: {reading['timestamp']}")
        print(f"⚡ State: {reading['lab_state']} ({self.lab_states[reading['lab_state']]['description']})")
        print(f"{'─'*70}")
        print(f"📈 Voltage:     {reading['voltage']:>8.2f} V")
        print(f"📈 Current:     {reading['current']:>8.2f} A")
        print(f"⚡ Power:       {reading['power_watts']:>8.2f} W")
        print(f"💡 Energy:      {reading['power_kwh']:>8.6f} kWh")
        print(f"🌍 CO₂:         {reading['co2_kg']:>8.6f} kg")
        print(f"{'─'*70}")
        print(f"📊 Total Energy: {reading['total_kwh']:>8.4f} kWh")
        print(f"🌍 Total CO₂:    {reading['total_co2_kg']:>8.4f} kg")
        
        if not success:
            print(f"⚠️  Error: {message}")
        elif isinstance(message, dict) and message.get('warning'):
            print(f"\n⚠️  WARNING: {message['warning']}")
        
        print(f"{'='*70}")
    
    def start(self, interval_seconds=3, duration_minutes=None):
        """Start the smart meter simulation"""
        self.running = True
        start_time = time.time()
        
        print(f"""
╔══════════════════════════════════════════════════════════════════╗
║           🔌 VIRTUAL SMART METER SIMULATOR                       ║
║           Computer Lab Energy Monitoring System                  ║
╚══════════════════════════════════════════════════════════════════╝

Lab Name: {self.lab_name}
Backend: {self.backend_url}
Interval: {interval_seconds} seconds
Duration: {'Continuous' if duration_minutes is None else f'{duration_minutes} minutes'}

Starting simulation...
Press Ctrl+C to stop
""")
        
        try:
            while self.running:
                # Generate and send reading
                reading = self.generate_reading()
                success, message = self.send_to_backend(reading)
                self.print_reading(reading, success, message)
                
                # Change lab state randomly
                self.change_lab_state()
                
                # Check duration
                if duration_minutes:
                    elapsed = (time.time() - start_time) / 60
                    if elapsed >= duration_minutes:
                        print(f"\n✅ Simulation completed ({duration_minutes} minutes)")
                        break
                
                # Wait before next reading
                time.sleep(interval_seconds)
                
        except KeyboardInterrupt:
            print(f"\n\n🛑 Simulation stopped by user")
            self.print_summary()
        except Exception as e:
            print(f"\n❌ Error: {e}")
    
    def print_summary(self):
        """Print simulation summary"""
        print(f"""
╔══════════════════════════════════════════════════════════════════╗
║                    SIMULATION SUMMARY                            ║
╚══════════════════════════════════════════════════════════════════╝

Total Readings:      {self.reading_count}
Total Energy:        {self.total_kwh:.4f} kWh
Total CO₂ Emitted:   {self.total_kwh * 0.8:.4f} kg
Average Power:       {(self.total_kwh * 3600 * 1000 / self.reading_count):.2f} W

💰 Estimated Cost:   ₹{self.total_kwh * 7:.2f} (@ ₹7/kWh)
🌳 Trees Needed:     {(self.total_kwh * 0.8 / 21):.2f} trees to offset
                     (1 tree absorbs ~21 kg CO₂/year)
""")

def main():
    """Main function"""
    import sys
    
    # Configuration
    LAB_NAME = "Computer Lab - Block A"
    BACKEND_URL = "http://localhost:5000"
    INTERVAL_SECONDS = 3  # Send reading every 3 seconds
    DURATION_MINUTES = None  # Run continuously (None) or set duration
    
    # Allow command line arguments
    if len(sys.argv) > 1:
        if sys.argv[1] == '--help':
            print("""
Usage: python smart_meter_simulator.py [options]

Options:
  --help              Show this help message
  --interval N        Set reading interval in seconds (default: 3)
  --duration N        Set simulation duration in minutes (default: continuous)
  --backend URL       Set backend URL (default: http://localhost:5000)
  --lab NAME          Set lab name (default: Computer Lab - Block A)

Examples:
  python smart_meter_simulator.py
  python smart_meter_simulator.py --interval 5 --duration 10
  python smart_meter_simulator.py --backend http://192.168.1.100:5000
""")
            return
        
        # Parse arguments
        for i in range(1, len(sys.argv), 2):
            if sys.argv[i] == '--interval' and i+1 < len(sys.argv):
                INTERVAL_SECONDS = int(sys.argv[i+1])
            elif sys.argv[i] == '--duration' and i+1 < len(sys.argv):
                DURATION_MINUTES = int(sys.argv[i+1])
            elif sys.argv[i] == '--backend' and i+1 < len(sys.argv):
                BACKEND_URL = sys.argv[i+1]
            elif sys.argv[i] == '--lab' and i+1 < len(sys.argv):
                LAB_NAME = sys.argv[i+1]
    
    # Create and start simulator
    simulator = SmartMeterSimulator(lab_name=LAB_NAME, backend_url=BACKEND_URL)
    simulator.start(interval_seconds=INTERVAL_SECONDS, duration_minutes=DURATION_MINUTES)

if __name__ == "__main__":
    main()
