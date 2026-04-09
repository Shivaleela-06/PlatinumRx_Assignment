def convert_minutes(minutes):
    hours = minutes // 60
    mins = minutes % 60

    if hours > 0:
        return f"{hours} hrs {mins} minutes"
    else:
        return f"{mins} minutes"  

