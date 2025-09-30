# Create frappe user
RUN useradd -ms /bin/bash frappe
WORKDIR /home/frappe

# Copy your Frappe project
COPY . /home/frappe/frappe-bench
RUN chown -R frappe:frappe /home/frappe/frappe-bench

# Switch to frappe user
USER frappe
WORKDIR /home/frappe/frappe-bench

# Upgrade pip and install bench
RUN pip install --upgrade pip --user
RUN pip install frappe-bench==5.25.9 --user

# Install Python dependencies
RUN pip install -r requirements.txt --user

# Setup bench
RUN ~/.local/bin/bench setup requirements
RUN ~/.local/bin/bench build

# Expose Frappe port
EXPOSE 8000

# Start bench
CMD ["~/.local/bin/bench", "start"]
