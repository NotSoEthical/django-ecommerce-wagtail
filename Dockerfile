FROM python:3.6
LABEL maintainer="corpofhack@gmail.com"

ENV PYTHONUNBUFFERED 1
ENV DJANGO_ENV production
ENV DJANGO_DB_NAME=default



COPY ./requirements.txt /code/requirements.txt
RUN pip install -r /code/requirements.txt
RUN pip install gunicorn
RUN pip install django-csp
RUN pip install WhiteNoise


COPY . /code/
WORKDIR /code/


RUN python manage.py migrate
RUN useradd wagtail
RUN chown -R wagtail /code
RUN python manage.py collectstatic
USER wagtail

EXPOSE 8000
CMD exec gunicorn snipcartwagtaildemo.wsgi:application --bind 0.0.0.0:8000 --workers 3

