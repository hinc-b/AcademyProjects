#pull official base image
FROM python:3.7-alpine

#set work directory
RUN mkdir /app
WORKDIR /app
COPY ./flask /app

#install dependencies
RUN python3 -m pip install -r requirements.txt
EXPOSE 8000
CMD ["gunicorn", "-w 4", "-b", "0.0.0.0:8000", "main:app"]