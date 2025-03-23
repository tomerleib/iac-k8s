{ pkgs ? import <nixpkgs> { config = { allowUnfree = true; }; } }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    # Infrastructure tools
    terraform
    kubectl
    kind
    kubernetes-helm

    # Container tools
    docker
    docker-compose

    # Additional utilities
    jq
    yq
    kubectx
    k9s
  ];

  shellHook = ''
    echo "Kubernetes Infrastructure Development Environment"
    echo "Available tools:"
    echo "  - terraform: $(terraform --version)"
    echo "  - kubectl: $(kubectl version --client)"
    echo "  - kind: $(kind version)"
    echo "  - helm: $(helm version --short)"
    echo "  - docker: $(docker --version)"
    echo ""
    echo "To get started:"
    echo "1. Initialize Terraform: terraform init"
    echo "2. Review the plan: terraform plan"
    echo "3. Apply changes: terraform apply"
  '';
} 