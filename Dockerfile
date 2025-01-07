# Use an official Python runtime as a parent image
FROM python:3.12.0

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Set environment variable for the port
ENV PORT 2004
#test
# Expose the port to the outside world
EXPOSE 2004
#test
RUN pip install --upgrade pip
RUN pip install -r requirements.txt
# Run the application
CMD ["/bin/bash", "-c", "python3 Api.py"]
