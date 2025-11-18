<template>
  <div class="flex flex-wrap items-stretch">
    <div class="min-h-screen w-1/2">
      <div class="flex flex-wrap items-center justify-between p-6">
        <h1 class="font-mono text-gray-700">Amazon EBS Builder</h1>
        <a
          class="shadow bg-blue-500 leading-none px-4 py-2 rounded text-white text-sm hover:bg-blue-600"
          href="https://packer.io/docs/builders/amazon-ebs.html"
          target="_blank"
          >docs</a
        >
      </div>
      <form class="px-6" @submit.prevent>
        <div class="flex items-center justify-between mt-4">
          <label class="block mr-2 w-1/2">
            <span class="text-gray-700">Access Key</span>
            <span class="block text-gray-600 text-sm"
              >The access key used to communicate with AWS</span
            >
            <input
              autofocus
              class="block border border-gray-300 rounded mt-1 w-full px-3 py-2"
              v-model="accessKey"
              type="text"
            />
          </label>
          <label class="block ml-2 w-1/2">
            <span class="text-gray-700">Secret Key</span>
            <span class="block text-gray-600 text-sm"
              >The secret key used to communicate with AWS</span
            >
            <input
              class="block border border-gray-300 rounded mt-1 w-full px-3 py-2"
              v-model="secretKey"
              type="password"
            />
          </label>
        </div>
        <label class="block mt-4">
          <span class="text-gray-700">Region</span>
          <span class="block text-gray-600 text-sm"
            >The name of the region in which to launch the EC2 instance to
            create the AMI</span
          >
          <select class="block border border-gray-300 rounded mt-1 w-full px-3 py-2" v-model="region">
            <option disabled value="">Region</option>
            <option>us-east-1</option>
          </select>
        </label>
        <label class="block mt-4">
          <span class="text-gray-700">Source AMI</span>
          <span class="block text-gray-600 text-sm"
            >The source AMI whose root volume will be copied and provisioned on
            the currently running instance</span
          >
          <input
            class="block border border-gray-300 rounded mt-1 w-full px-3 py-2"
            v-model="sourceAmi"
            type="text"
          />
        </label>
        <label class="block mt-4">
          <span class="text-gray-700">Name</span>
          <span class="block text-gray-600 text-sm"
            >The name of the resulting AMI</span
          >
          <input
            class="block border border-gray-300 rounded mt-1 w-full px-3 py-2"
            v-model="amiName"
            type="text"
          />
        </label>
        <label class="block mt-4">
          <span class="text-gray-700">Instance Type</span>
          <span class="block text-gray-600 text-sm"
            >The EC2 instance type to use while building the AMI</span
          >
          <select class="block border border-gray-300 rounded mt-1 w-full px-3 py-2" v-model="instanceType">
            <option disabled value="">Instance Type</option>
            <option>t2.small</option>
          </select>
        </label>
        <label class="block mt-4">
          <span class="text-gray-700">SSH Username</span>
          <span class="block text-gray-600 text-sm"
            >The username to connect to SSH with</span
          >
          <input
            class="block border border-gray-300 rounded mt-1 w-full px-3 py-2"
            v-model="sshUsername"
            type="text"
          />
        </label>
        <div class="flex flex-wrap items-center mt-6">
          <div class="block flex-grow">
            <button
              class="shadow bg-blue-500 border border-blue-500 focus:outline-none hover:bg-blue-600 hover:border-blue-600 mb-4 mr-4 px-4 py-2 rounded text-white"
              @click="generate"
            >
              <span class="block flex items-center">
                Generate
                <svg
                  class="fill-current h-3 ml-2 w-3"
                  xmlns="http://www.w3.org/2000/svg"
                  viewBox="0 0 20 20"
                >
                  <path
                    d="M16.172 9l-6.071-6.071 1.414-1.414L20 10l-.707.707-7.778 7.778-1.414-1.414L16.172 11H0V9z"
                  />
                </svg>
              </span>
            </button>
            <button
              class="shadow border border-transparent focus:outline-none hover:bg-gray-200 mb-4 mr-4 px-4 py-2 rounded"
              @click="copy"
            >
              <span class="block flex items-center text-gray-700">
                Copy
                <svg
                  class="fill-current h-3 ml-2 w-3"
                  xmlns="http://www.w3.org/2000/svg"
                  viewBox="0 0 20 20"
                >
                  <path
                    d="M6 6V2c0-1.1.9-2 2-2h10a2 2 0 0 1 2 2v10a2 2 0 0 1-2 2h-4v4a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V8c0-1.1.9-2 2-2h4zm2 0h4a2 2 0 0 1 2 2v4h4V2H8v4zM2 8v10h10V8H2z"
                  />
                </svg>
              </span>
            </button>
          </div>
          <button
            class="shadow border border-transparent focus:outline-none hover:bg-gray-200 mb-4 px-4 py-2 rounded text-gray-700"
            @click="clear"
          >
            Clear
          </button>
        </div>
      </form>
    </div>
    <div class="bg-gray-100 font-mono min-h-screen p-6 text-gray-700 w-1/2">
      <div class="flex flex-grow flex-wrap items-center justify-between mb-8">
        <p class="block flex items-center select-none">
          <svg
            class="h-5 fill-current mr-2 w-5"
            xmlns="http://www.w3.org/2000/svg"
            viewBox="0 0 20 20"
          >
            <path
              d="M.7 9.3l4.8-4.8 1.4 1.42L2.84 10l4.07 4.07-1.41 1.42L0 10l.7-.7zm18.6 1.4l.7-.7-5.49-5.49-1.4 1.42L17.16 10l-4.07 4.07 1.41 1.42 4.78-4.78z"
            />
          </svg>
          template.json
        </p>
        <label class="block flex flex-wrap items-center">
          <span class="mr-2 select-none">Spaces</span>
          <select class="block border border-gray-300 rounded px-3 py-2" v-model.number="indent">
            <option disabled value="">---</option>
            <option :value="2">2</option>
            <option :value="4">4</option>
          </select>
        </label>
      </div>
      <div class="text-gray-700 whitespace-pre-wrap" id="template">{{ templateJson }}</div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'

const indent = ref(2)
const amiName = ref('')
const accessKey = ref('')
const region = ref('us-east-1')
const secretKey = ref('')
const instanceType = ref('t2.small')
const sourceAmi = ref('')
const sshUsername = ref('root')

const template = ref({
  _comment: 'Template created using Punk: https://github.com/jasonwalsh/punk',
  builders: []
})

const templateJson = computed(() => {
  return JSON.stringify(template.value, null, ' '.repeat(indent.value))
})

const clear = () => {
  template.value.builders.pop()
}

const copy = () => {
  const templateEl = document.getElementById('template')
  const selection = window.getSelection()
  const range = document.createRange()
  range.selectNodeContents(templateEl)
  selection.removeAllRanges()
  selection.addRange(range)
  document.execCommand('copy')
  selection.removeRange(range)
  alert('Template copied to clipboard!')
}

const generate = () => {
  template.value.builders.pop()
  const builder = {
    access_key: accessKey.value,
    ami_name: amiName.value,
    instance_type: instanceType.value,
    region: region.value,
    secret_key: secretKey.value,
    source_ami: sourceAmi.value,
    ssh_username: sshUsername.value,
    type: 'amazon-ebs'
  }
  template.value.builders.push(builder)
}
</script>
