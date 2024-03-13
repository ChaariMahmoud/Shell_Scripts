#!/bin/bash

# Update package lists
sudo apt update

# Install OpenJDK 11
sudo apt install -y openjdk-11-jdk

# Create a new user 'hadoop'
sudo adduser hadoop

# Add hadoop user to sudo group
sudo usermod -aG sudo hadoop

# Switch to the hadoop user
sudo -u hadoop -H sh -c 'cd ~'

# Download and extract Hadoop
wget https://downloads.apache.org/hadoop/common/hadoop-3.3.6/hadoop-3.3.6.tar.gz
sudo tar -xzvf hadoop-3.3.6.tar.gz -C /usr/local
sudo mv /usr/local/hadoop-3.3.6 /usr/local/hadoop
rm hadoop-3.3.6.tar.gz

# Set Java environment variables for the hadoop user
sudo -u hadoop -H sh -c 'echo "export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64" >> ~/.bashrc'
sudo -u hadoop -H sh -c 'echo "export PATH=\$PATH:\$JAVA_HOME/bin" >> ~/.bashrc'

# Set Hadoop environment variables for the hadoop user
sudo -u hadoop -H sh -c 'echo "export HADOOP_HOME=/usr/local/hadoop" >> ~/.bashrc'
sudo -u hadoop -H sh -c 'echo "export PATH=\$PATH:\$HADOOP_HOME/bin:\$HADOOP_HOME/sbin" >> ~/.bashrc'

# Configure Hadoop
sudo -u hadoop -H sh -c 'mkdir -p /usr/local/hadoop_tmp/hdfs/namenode'
sudo -u hadoop -H sh -c 'mkdir -p /usr/local/hadoop_tmp/hdfs/datanode'

sudo -u hadoop -H sh -c 'cp /usr/local/hadoop/etc/hadoop/core-site.xml /usr/local/hadoop/etc/hadoop/core-site.xml.backup'
sudo -u hadoop -H sh -c 'cp /usr/local/hadoop/etc/hadoop/hdfs-site.xml /usr/local/hadoop/etc/hadoop/hdfs-site.xml.backup'

sudo -u hadoop -H sh -c 'cat <<EOF | tee /usr/local/hadoop/etc/hadoop/core-site.xml
<configuration>
  <property>
    <name>fs.defaultFS</name>
    <value>hdfs://localhost:9000</value>
  </property>
</configuration>
EOF'

sudo -u hadoop -H sh -c 'cat <<EOF | tee /usr/local/hadoop/etc/hadoop/hdfs-site.xml
<configuration>
  <property>
    <name>dfs.replication</name>
    <value>1</value>
  </property>
  <property>
    <name>dfs.namenode.name.dir</name>
    <value>/usr/local/hadoop_tmp/hdfs/namenode</value>
  </property>
  <property>
    <name>dfs.datanode.data.dir</name>
    <value>/usr/local/hadoop_tmp/hdfs/datanode</value>
  </property>
</configuration>
EOF'

# Create yarn-site.xml
sudo -u hadoop -H sh -c 'cp $HADOOP_HOME/etc/hadoop/yarn-site.xml.template $HADOOP_HOME/etc/hadoop/yarn-site.xml'

# Add YARN configurations to yarn-site.xml
sudo -u hadoop -H sh -c 'cat <<EOF | tee -a $HADOOP_HOME/etc/hadoop/yarn-site.xml
<configuration>
  <property>
    <name>yarn.nodemanager.aux-services</name>
    <value>mapreduce_shuffle</value>
  </property>
  <property>
    <name>yarn.nodemanager.aux-services.mapreduce_shuffle.class</name>
    <value>org.apache.hadoop.mapred.ShuffleHandler</value>
  </property>
  <!-- Add any additional YARN configurations here -->
</configuration>
EOF'

# Format Hadoop filesystem
sudo -u hadoop -H sh -c 'hdfs namenode -format'

# Function to start Hadoop
start_hadoop() {
    sudo -u hadoop -H sh -c '$HADOOP_HOME/sbin/start-dfs.sh'
}

# Function to start YARN
start_yarn() {
    sudo -u hadoop -H sh -c '$HADOOP_HOME/sbin/start-yarn.sh'
}

# Function to stop Hadoop
stop_hadoop() {
    sudo -u hadoop -H sh -c '$HADOOP_HOME/sbin/stop-dfs.sh'
}

# Function to stop YARN
stop_yarn() {
    sudo -u hadoop -H sh -c '$HADOOP_HOME/sbin/stop-yarn.sh'
}

# Add start-hadoop and start-yarn functions to .bashrc
sudo -u hadoop -H sh -c 'echo "start-hadoop() {" >> ~/.bashrc'
sudo -u hadoop -H sh -c 'echo "    sudo -u hadoop -H sh -c '\''\$HADOOP_HOME/sbin/start-dfs.sh'\''" >> ~/.bashrc'
sudo -u hadoop -H sh -c 'echo "}" >> ~/.bashrc'

sudo -u hadoop -H sh -c 'echo "start-yarn() {" >> ~/.bashrc'
sudo -u hadoop -H sh -c 'echo "    sudo -u hadoop -H sh -c '\''\$HADOOP_HOME/sbin/start-yarn.sh'\''" >> ~/.bashrc'
sudo -u hadoop -H sh -c 'echo "}" >> ~/.bashrc'

# Source .bashrc to apply changes
sudo -u hadoop -H sh -c 'source ~/.bashrc'

# Verify Hadoop installation
sudo -u hadoop -H sh -c '$HADOOP_HOME/bin/hadoop version'
