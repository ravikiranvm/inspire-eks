# Use python slim image to keep the image size small
FROM python:3.10-slim

# Working Directory
WORKDIR /app

# Copy requirements and install dependencies
COPY ./requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# Copy the backend code
COPY ./app.py /app/

#Expose the Flask app port
EXPOSE 5001

# Run the Flask app
CMD ["python", "app.py"]