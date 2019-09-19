#  Event Format
This document describes the event format that each sensor outputs.

**Meta - Simple sensor - meta information about the sensor**
```
{
    "timestamp":date!.timeIntervalSince1970,
    "name":"Name of the sensor"
    "sensortype":SensorEnumeration,
    "type":"meta"
    "channels":{
        "description":"describes the sensor",
        "":""
    }
    "event":{Event from the sensor}
}
```

**Event - Simple sensor**
```
{
    "timestamp":date!.timeIntervalSince1970,
    "Sensortype":SensorEnumeration,
    "type":"event"
    "event":{Event from the sensor}
}
```

**Event - Simple sensor meta**
```
{
    "meta1":date!.timeIntervalSince1970,
    "meta2":SensorEnumeration,
    "meta3":"something"
    "event":{
        data from the sensor
    }
}
```

Bluetooth devices that talks to the application may use other forms of events, thus the application should convert to the standard format.
