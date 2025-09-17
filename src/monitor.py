import time, re, requests
from collections import deque

LOG_FILE = "predictions.log"
THRESHOLD = 0.5
WINDOW_LINES = 20
CHECK_INTERVAL = 10
WEBHOOK_URL = ""  # set to your webhook

def tail(filepath):
    with open(filepath, "r") as f:
        f.seek(0,2)
        while True:
            line = f.readline()
            if not line:
                time.sleep(1)
                continue
            yield line

def send_alert(summary):
    if not WEBHOOK_URL:
        print("ALERT would be sent but WEBHOOK_URL is empty: ", summary)
        return
    payload = {"text": f"ALERT: High error rate detected: {summary}"}
    requests.post(WEBHOOK_URL, json=payload, timeout=5)

def monitor():
    buf = deque(maxlen=WINDOW_LINES)
    while True:
        try:
            for line in tail(LOG_FILE):
                buf.append(line)
                if len(buf) >= WINDOW_LINES:
                    errs = sum(1 for l in buf if re.match(r".*ERR.*", l))
                    frac = errs / len(buf)
                    if frac > THRESHOLD:
                        send_alert({"error_count": errs, "total": len(buf), "fraction": frac})
                        buf.clear()
        except FileNotFoundError:
            time.sleep(2)
            continue

if __name__ == "__main__":
    monitor()
