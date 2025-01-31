## What is a GPU?
A Graphical Processing Unit (GPU) is a specialized electronic circuit designed to accelerate the processing of images and videos for display. While Central Processing Units (CPUs) handle the general tasks of a computer, GPUs take care of the graphics and visual aspects. However, their role has expanded significantly beyond just graphics. Over the years, the immense processing power of GPUs has been harnessed for a broader range of applications, especially in areas that require handling vast amounts of math operations simultaneously. This includes fields like artificial intelligence, deep learning, scientific simulations, and, of course, machine learning. The reason GPUs are so efficient for these tasks is their architecture. Unlike CPUs that have a few cores optimized for sequential serial processing, GPUs have thousands of smaller cores designed for multi-tasking and handling parallel operations. This makes them exceptionally good at performing multiple tasks at once. 

# GPU concurrency 
GPU concurrency refers to the ability of the GPU to handle multiple tasks or processes simultaneously. There are different strategies to acheive this one of them is time slicing.
- Single Process in CUDA
- Multi-process with CUDA
- Time-slicing
- Multi-Instance GPU
- Virtualization with virtual GPU (vGPU)


# Time-slicing (also know as GPU slicing)
The simplest approach for sharing an entire GPU is time-slicing, which is akin to giving each process a turn at using the GPU, with every process scheduled to use the GPU in a round-robin fashion. This method provides access for those slices, but there is no control over how many resources a process can request, leading to potential out-of-memory issues if we don't control or understand the workloads involved.

- Time-slicing is Allowing multiple workloads to share GPUs by alternating execution time
- Time-slicing involves dividing GPU access into small time intervals, allowing different tasks to use the GPU in these predefined slices. It’s akin to how a CPU might time-slice between different processes.
- Suitable for environments with multiple tasks that need intermittent GPU access.

# Time-slicing Benefits
- Improved resource utilization: GPU sharing allows for better utilization of GPU resources by enabling multiple pods to use the same GPU. This means that even smaller workloads that don’t require the full power of a GPU can still benefit from GPU acceleration without wasting resources.
- Cost optimization: GPU sharing can help reduce costs by improving resource utilization. With GPU sharing, you can run more workloads on the same number of GPUs, effectively spreading the cost of those GPUs across more workloads.
- Increased throughput: GPU sharing enhances the system’s overall throughput by enabling multiple workloads to operate at once. This is especially advantageous during periods of intense demand or high load situations, where there’s a surge in the number of simultaneous requests. By addressing more requests within the same timeframe, the system achieves improved resource utilization, leading to optimized performance.
- Flexibility: ime-slicing can accommodate a variety of workloads, from machine learning tasks to graphics rendering, allowing diverse applications to share the same GPU.
- Compatibility: Time-slicing can be beneficial for older generation GPUs that don’t support other sharing mechanisms like MIG.

# Time-slicing Drawbacks
- No memory or fault isolation: Unlike mechanisms like MIG, time-slicing doesn’t provide memory or fault isolation between tasks. If one task crashes or misbehaves, it can affect others sharing the GPU.
- Potential latency: As tasks take turns using the GPU, there might be slight delays, which could impact real-time or latency-sensitive applications.
- Complex resource management: Ensuring fair and efficient distribution of GPU resources among multiple tasks can be challenging. For more information, refer to Improving GPU utilization in Kubernetes.
- Overhead: The process of switching between tasks can introduce overhead in terms of computational time and resources, especially if the switching frequency is high. This can potentially lead to reduced overall performance for the tasks being executed.

# Importance of time-slicing for GPU-intensive workloads
Time-slicing, in the context of GPU sharing on platforms like Amazon EKS, refers to the method where multiple tasks or processes share the GPU resources in small time intervals, ensuring efficient utilization and task concurrency.

Here are scenarios and workloads that are prime candidates for time-slicing:

**Multiple small-scale workloads:** For organizations running multiple small-to medium-sized workloads simultaneously, time-slicing ensures that each workload gets a fair share of the GPU, maximizing throughput without the need for multiple dedicated GPUs.

**Development and testing environments:** In scenarios where developers and data scientists are prototyping, testing, or debugging models, they might not need continuous GPU access. Time-slicing allows multiple users to share GPU resources efficiently during these intermittent usage patterns.

**Batch processing:** For workloads that involve processing large datasets in batches, time-slicing can ensure that each batch gets dedicated GPU time, leading to consistent and efficient processing.

**Real-time analytics:** In environments where real-time data analytics is crucial, and data arrives in streams, time-slicing ensures that the GPU can process multiple data streams concurrently, delivering real-time insights.

**Simulations:** For industries like finance or healthcare, where simulations are run periodically but not continuously, time-slicing can allocate GPU resources to these tasks when needed, ensuring timely completion without resource waste.

**Hybrid workloads:** In scenarios where an organization runs a mix of AI, ML, and traditional computational tasks, time-slicing can dynamically allocate GPU resources based on the immediate demand of each task.

**Cost efficiency:** For startups or small-and medium-sized enterprises with budget constraints, investing in a fleet of GPUs might not be feasible. Time-slicing allows them to maximize the utility of limited GPU resources, catering to multiple users or tasks without compromising performance.

# Configuring the NVIDIA GPU operator on Kubernetes

The NVIDIA GPU operator can be configured to use the Kubernetes device plugin to manage GPU resources efficiently within the cluster. The NVIDIA GPU operator streamlines the deployment and management of GPU workloads by automating the setup of the necessary drivers and runtime components. With the Kubernetes device plugin, the operator integrates with Kubernetes’ resource management capabilities, allowing for dynamic allocation and deallocation of GPU resources as needed by the workloads.

For Amazon EKS, users can enable GPU sharing by integrating the NVIDIA Kubernetes device plugin. This plugin exposes the GPU device resources to the Kubernetes system. By doing so, the Kubernetes scheduler can now factor in these GPU resources when making scheduling decisions, ensuring that workloads requiring GPU resources are appropriately allocated without the system directly managing the GPU devices themselves.

GPU time-slicing in Kubernetes allows tasks to share a GPU by taking turns. This is especially useful when the GPU is oversubscribed. System administrators can create “replicas” for a GPU, with each replica designated to a specific task or pod


# Implementing  GPU slicing for EKS clusters that has Karpenter Autoscaler installed

## Pre-requisites:
- [Install helm](https://helm.sh/docs/intro/install/)
- [Install AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- [Install kubectl](https://kubernetes.io/docs/tasks/tools/)
- [Install jq](https://jqlang.github.io/jq/download/)
- Ensure Karpenter is running on the cluster

- create a new GPU instance node group for the cluster using karpenter nodepool configuration

```
apiVersion: karpenter.sh/v1beta1
kind: NodePool
metadata:
  name: gpu-nodepool
  labels:
    instance-type: eks-node=gpu
spec:
  requirements:
  - key: "kubernetes.io/arch"
    operator: In
    values: ["amd64"] 
  - key: "kubernetes.io/os"
    operator: In
    values: ["linux"]
  - key: "nvidia.com/gpu"
    operator: Exists # This ensures only nodes with GPUs are launched
  - key: "karpenter.k8s.aws/instance-type"
    operator: In
    values: 
      - "g4dn.xlarge" 
      - "g4dn.2xlarge" 
      - "g4dn.4xlarge" 
      # Add more GPU instance types as needed
  ttlSecondsAfterEmpty: 3600 # Delete nodes after 1 hour of inactivity
```

- Apply the nodepool YAML file `kubectl apply -f gpu-nodepool.yaml`

- Confirm the nodes have been successfully provsioned by running this command `kubectl get nodes`

- Install the NVIDIA Kubernetes device plugin using the Helm chart on the GPU node (it is deployed as a daemonset)
```
helm upgrade -i nvdp nvdp/nvidia-device-plugin \
  --namespace kube-system \
  -f nvdp-values.yaml \
  --version 0.14.0
```
PS: The Helm nvdp-values.yaml  file can be found in [eks-gpu-sharing-demo repo](https://github.com/sanjeevrg89/eks-gpu-sharing-demo/blob/main/nvdp-values.yaml)


- Enable time-slicing configuration using configmap, Create a ConfigMap  with the script below

```
cat << EOF > nvidia-device-plugin.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: nvidia-device-plugin
  namespace: kube-system
data:
  any: |-
    version: v1
    flags:
      migStrategy: none
    sharing:
      timeSlicing:
        resources:
        - name: nvidia.com/gpu
          replicas: 10
EOF
```

- Apply the configmap `kubectl apply -f nvidia-device-plugin.yaml`

- Update your NVIDIA Kubernetes device plugin with the new ConfigMap that has time-slicing configuration

```
helm upgrade -i nvdp nvdp/nvidia-device-plugin \
  --namespace kube-system \
  -f nvdp-values.yaml \
  --version 0.14.0 \
  --set config.name=nvidia-device-plugin \
  --force
```




# Resources
- [GPU sharing on Amazon EKS with NVIDIA time-slicing and accelerated EC2 instances](https://aws.amazon.com/blogs/containers/gpu-sharing-on-amazon-eks-with-nvidia-time-slicing-and-accelerated-ec2-instances/)
- [Red HAT - Sharing is caring](https://www.redhat.com/en/blog/sharing-caring-how-make-most-your-gpus-part-1-time-slicing)
- [NIVIDIA GPU Operato](https://docs.nvidia.com/datacenter/cloud-native/gpu-operator/latest/gpu-sharing.html)
- [Helm Operator](https://github.com/NVIDIA/gpu-operator)
- [eks-gpu-sharing-demo repo](https://github.com/sanjeevrg89/eks-gpu-sharing-demo/blob/main/nvdp-values.yaml)
- [Karpenter Nodepools](https://karpenter.sh/docs/concepts/nodepools/)