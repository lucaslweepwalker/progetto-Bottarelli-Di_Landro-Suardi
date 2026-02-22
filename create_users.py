import csv
import random
import numpy as np

# Sample name pools
FIRST_NAMES = [
    "Liam", "Olivia", "Noah", "Emma", "Oliver", "Ava", "Elijah", "Sophia",
    "William", "Isabella", "James", "Mia", "Benjamin", "Charlotte",
    "Lucas", "Amelia", "Henry", "Harper", "Alexander", "Evelyn"
]

LAST_NAMES = [
    "Smith", "Johnson", "Williams", "Brown", "Jones", "Garcia",
    "Miller", "Davis", "Rodriguez", "Martinez", "Hernandez", "Lopez",
    "Gonzalez", "Wilson", "Anderson", "Thomas", "Taylor", "Moore"
]


def generate_unique_ips(count):
    ip_pool = set()
    while len(ip_pool) < count:
        x = random.randint(0, 255)
        y = random.randint(1, 254)
        ip_pool.add(f"192.168.{x}.{y}")
    return list(ip_pool)


def weighted_level():
    return random.choices([1, 2, 3], weights = [65, 30, 5], k = 1)[0]


def random_name():
    first = random.choice(FIRST_NAMES)
    last = random.choice(LAST_NAMES)
    return first, last


def random_password(length = 8):
    chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!?@#$%^()&*"
    return ''.join(random.choice(chars) for _ in range(length))


def main():
    OUTPUT_PATH = "/workspaces/codespaces-blank/progetto-Bottarelli-Di_Landro-Suardi/intranet_sim/data/users.csv"
    
    users = 100
    rows = []

    unique_ips = generate_unique_ips(users)


    for user_id in range(1, users + 1):
        first, last = random_name()
        name_surname = f"{first} {last}"
        mail = f"{first.lower()}.{last.lower()}@mail.com"
        password = random_password()
        
        if user_id > np.percentile(range(1, users + 1), 92):
            level = 0
        else:                
            level = weighted_level()
        
        ip = unique_ips[user_id -1]

        rows.append([user_id, name_surname, mail, password, level, ip])

    with open(OUTPUT_PATH, mode="w", newline="") as file:
        writer = csv.writer(file)
        # FIX: header matches exactly the fields we write
        writer.writerow(["id", "name_surname", "mail", "password", "level", "ip_address"])
        writer.writerows(rows)

    print(f"[OK] Generated {users} users -> {OUTPUT_PATH}")


if __name__ == "__main__":
    main()
