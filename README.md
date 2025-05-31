# docker-qdevice
Docker-qdevice is a docker image that uses corosync to act as a qdevice for a two node proxmox cluster

## Features
- Provides a corosync qdevice for two-node Proxmox clusters.
- Lightweight and easy to deploy using Docker.
- Ensures quorum in a two-node cluster setup.

## Requirements
- Docker installed on the host machine.
- A two-node Proxmox cluster configured with corosync.

## Usage

1. Create the authorized_keys file with the public key of the Proxmox Node from where you add the qdevice to the cluster. It is only needed for the initial setup.

2. Run the container:
    ```docker compose
    services:
      qdevice:
        image: ghcr.io/BluePhi09/docker-qdevice
        ports:
          - 22:22
          - 5403:5403
        volumes:
          - ./authorized_keys:/root/authorized_keys.old
          - authorized_keys:/root/.ssh/
          - corosync_data:/etc/corosync
          - ssh_data:/etc/ssh
        restart: unless-stopped
        
    volumes:
      - corosync_data
      - authorized_keys
      - ssh_data
    ```
    
3. Install corosync-qdevice on all proxmox nodes for the qdevice setup to work:
    ```bash
    apt update
    apt install corosync-qdevice
    ```   

4. Configure the Proxmox cluster to use the qdevice:
    ```bash
    pvecm qdevice setup 192.168.30.226
    ```

## Configuration
- The container uses the host network to communicate with the Proxmox cluster.
- Ensure that the required ports for corosync are open and accessible.

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contributing
Contributions are welcome! Please open an issue or submit a pull request for any improvements or bug fixes.

## Acknowledgments
This project was heavily inspired by the work done in [Sysadminfromhell/corosyncdevice](https://github.com/Sysadminfromhell/corosyncdevice). Many ideas and concepts were adapted and built upon to create this solution. A big thank you to the original authors for their contributions to the community!

## Disclaimer
This project is not officially affiliated with Proxmox. Use it at your own risk.
