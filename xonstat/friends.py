#!/usr/bin/env python2

from collections import defaultdict, deque
from datetime import date, datetime, time, timedelta

from flask import Flask, request, abort
from d0_blind_id import d0_blind_id_verify

import logging

log = logging.getLogger(__name__)
log.addHandler(logging.StreamHandler())
log.setLevel(logging.DEBUG)

keytoid = defaultdict(lambda: len(keytoid))  # TODO: replace with db lookup
queue = defaultdict(lambda: deque(maxlen=20))
timeoutperiod = timedelta(minutes=15)
activity = defaultdict(lambda: None)

app = Flask(__name__)

def accept():
    triple = (request.headers.get('X-D0-Blind-Id-Detached-Signature', None),
              request.query_string.decode(),
              request.stream.read().decode())
    (idfp, status) = d0_blind_id_verify(*triple)
    log.debug("d0_blind_id verification: idfp={0} status={1}".format(idfp, status))
    log.debug("----- BEGIN REQUEST BODY -----\n{0}\n----- END REQUEST BODY -----".format(triple))
    id = keytoid[idfp]
    now = datetime.combine(date.today(), time())
    activity[id] = now
    return id, now, triple[2]

@app.route('/send', methods=['POST'])
def send():
    (src, now, msg) = accept()
    dst = int(request.args.get('to'))
    ret = request.args.get('retain') in ['1']
    activity[src] = now
    log.debug("{0}@{1} -> {2}: {3}\n".format(src, now, dst, msg))

    if ret or activity[dst] and now - timeoutperiod <= activity[dst] <= now + timeoutperiod:
        queue[dst].extend([(src, msg)])
        if ret:  # TODO: persist
            pass
    return ""

@app.route('/recv', methods=['POST'])
def recv():
    (out, now, _) = accept()
    q = queue[out]
    if not len(q):
        abort(404)
    (src, msg) = q.popleft()
    log.debug("{0}@{1} <- {2}\n".format(out, now, (src, msg)))
    return "{0}\n{1}".format(src, msg)

if __name__ == '__main__':
    app.run(debug=True)
