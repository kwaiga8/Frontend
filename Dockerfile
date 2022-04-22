FROM python:3.8-slim-buster
WORKDIR /app
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txtexi
COPY . .
EXPOSE 5000
CMD ["python", "app.py"]