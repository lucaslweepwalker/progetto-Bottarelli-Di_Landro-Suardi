import csv
import os
import random
from datetime import datetime, timedelta


USERS_CSV   = "/workspaces/progetto-Bottarelli-Di_Landro-Suardi/intranet_sim/data/users.csv"
LOG_FILE    = "/workspaces/progetto-Bottarelli-Di_Landro-Suardi/intranet_sim/logs/access.log"
CONFIG_FILE = "/workspaces/progetto-Bottarelli-Di_Landro-Suardi/intranet_sim/config/settings.conf"

# Modificare questi valori per controllare il comportamento della simulazione.

# Numero di accessi generati casualmente
NUM_LOGS = 500

# Probabilità che un accesso normale provenga da un IP esterno
EXTERNAL_IP_PROB = 0.05

# Numero di utenti che genereranno un picco di banda in un singolo giorno
NUM_BURST_USERS = 4

# Numero di accessi concentrati in un giorno per ogni utente in burst
BURST_ACCESSES = 70


def load_users(csv_path):
    """Load users from CSV. Returns list of dicts with ip_address key."""
    users = []
    with open(csv_path, newline="") as f:
        reader = csv.DictReader(f)
        for row in reader:
            users.append({
                "ip": row["ip_address"],
            })
    return users


def load_settings(config_path):
    """Read START_HOUR and END_HOUR from settings.conf."""
    settings = {}
    with open(config_path, "r") as f:
        for line in f:
            line = line.strip()
            if line and "=" in line:
                key, value = line.split("=", 1)
                settings[key.strip()] = int(value.strip())
    return settings


def random_timestamp(start_hour, end_hour, night_weight=0.1):
    """
    Generate a random timestamp in 2025.
    Daytime hours (start_hour..end_hour) are much more frequent.
    Returns (date_str, time_str, is_night).
    """
    start_date = datetime(2025, 1, 1)
    end_date   = datetime(2025, 12, 31)

    days_between = (end_date - start_date).days
    ts = start_date + timedelta(days=random.randint(0, days_between))

    hours   = list(range(24))
    weights = [1.0 if start_hour <= h <= end_hour else night_weight for h in hours]
    hour    = random.choices(hours, weights=weights, k=1)[0]

    ts = ts.replace(hour=hour, minute=random.randint(0, 59), second=random.randint(0, 59))

    is_night = not (start_hour <= hour <= end_hour)
    return ts.strftime("%Y-%m-%d"), ts.strftime("%H:%M:%S"), is_night


def random_external_ip():
    """Generate a random IP outside the 192.168.x.x subnet."""
    while True:
        first  = random.choice([5, 8, 34, 52, 77, 93, 104, 142, 185, 212])
        second = random.randint(0, 255)
        third  = random.randint(0, 255)
        fourth = random.randint(1, 254)
        return f"{first}.{second}.{third}.{fourth}"


def random_pid():
    """Simulate a realistic Linux PID (100 – 65535)."""
    return random.randint(100, 65535)


def main():
    users    = load_users(USERS_CSV)
    settings = load_settings(CONFIG_FILE)

    start_hour = settings["START_HOUR"]
    end_hour   = settings["END_HOUR"] - 1

    log_entries = []

    for _ in range(NUM_LOGS):
        if random.random() < EXTERNAL_IP_PROB:
            ip = random_external_ip()
        else:
            ip = random.choice(users)["ip"]

        date_part, time_part, is_night = random_timestamp(start_hour, end_hour)
        error_code = "400" if is_night else "200"
        pid = random_pid()

        log_entries.append(f"{date_part}|{time_part}|{ip}|{error_code}|{pid}\n")

    burst_users = random.sample(users, NUM_BURST_USERS)
    for burst_user in burst_users:
        ip = burst_user["ip"]

        start_date = datetime(2025, 1, 1)
        burst_day  = start_date + timedelta(days=random.randint(0, 364))
        date_part  = burst_day.strftime("%Y-%m-%d")

        for _ in range(BURST_ACCESSES):
            hour      = random.randint(start_hour, end_hour)
            time_part = f"{hour:02d}:{random.randint(0,59):02d}:{random.randint(0,59):02d}"
            pid       = random_pid()
            log_entries.append(f"{date_part}|{time_part}|{ip}|200|{pid}\n")

    log_entries.sort()

    os.makedirs(os.path.dirname(LOG_FILE), exist_ok=True)
    with open(LOG_FILE, "w") as log:
        log.writelines(log_entries)

    total = len(log_entries)
    print(f"[OK] Generated {total} log entries ({NUM_LOGS} regular + {NUM_BURST_USERS * BURST_ACCESSES} burst) -> {LOG_FILE}")


if __name__ == "__main__":
    main()