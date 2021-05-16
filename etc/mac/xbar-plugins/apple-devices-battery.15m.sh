#!/bin/bash

# Metadata:
# <xbar.title>apple-devices-battery</xbar.title>
# <xbar.version>v1.0</xbar.version>
# <xbar.author>kawarimidoll</xbar.author>
# <xbar.author.github>kawarimidoll</xbar.author.github>
# <xbar.desc>Check batteries of apple bluetooth devices.</xbar.desc>
# <xbar.image></xbar.image>

ioreg -r -d 1 -k BatteryPercent | \
  grep -E '"BatteryPercent"|"Product"' | \
  sed -r 's/.*Product" = "(.*)"/\1/g' | \
  tr '\n' ' ' | \
  sed 's/ *"BatteryPercent" =/:/g' | \
  sed 's/$/%/'
  # sed -z 's/\n.*BatteryPercent" =/:/g' | \
