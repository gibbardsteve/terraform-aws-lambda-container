# Use the official Python image from the Docker Hub
FROM public.ecr.aws/lambda/python:3.11

# Copy only the pyproject.toml and poetry.lock to leverage Docker cache
COPY pyproject.toml poetry.lock ./

# Install Poetry
RUN curl -sSL https://install.python-poetry.org | python3 -

# Add Poetry to PATH
ENV PATH="/root/.local/bin:$PATH"

RUN pip install --user poetry-plugin-export

# Install dependencies using pip
RUN poetry export -f requirements.txt --output requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application, LAMBDA_TASK_ROOT preset in the
# lambda python image
COPY . ${LAMBDA_TASK_ROOT}

# Ensure the handler file has correct permissions
RUN chmod 644 lambda_function.py

# Set the CMD to your handler (could also be set as an environment variable)
CMD ["lambda_function.handler"]
