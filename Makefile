#!make
PING_DELAY_MS ?= 200

format:
	poetry run isort src/

run-one-thread:
	PING_DELAY_MS=${PING_DELAY_MS} \
	poetry run \
		uvicorn \
			--host localhost \
			--port 8000 \
			--workers 1 \
			src.server:app


run-four-threads:
	PING_DELAY_MS=${PING_DELAY_MS} \
	poetry run \
		uvicorn \
			--host localhost \
			--port 8000 \
			--workers 4 \
			src.server:app


test-one-thread:
	wrk \
		-c 20000 \
		-d 30s \
		-t 1 \
		http://localhost:8000/ping/

test-four-threads:
	wrk \
		-c 20000 \
		-d 30s \
		-t 4 \
		http://localhost:8000/ping/
