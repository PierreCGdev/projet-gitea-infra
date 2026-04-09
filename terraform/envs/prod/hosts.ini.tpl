[bastion]
${bastion_ip}

[traefik]
${traefik_ip}

[managers]
%{ for ip in manager_ips ~}
${ip}
%{ endfor ~}

[workers]
%{ for ip in worker_ips ~}
${ip}
%{ endfor ~}

[monitoring]
${monitoring_ip}

[swarm:children]
managers
workers

[private:children]
managers
workers
monitoring
traefik
