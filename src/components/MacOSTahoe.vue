<template>
  <div class="flex flex-wrap items-stretch">
    <div class="min-h-screen w-1/2">
      <div class="flex flex-wrap items-center justify-between p-6">
        <h1 class="font-mono text-gray-700">macOS Tahoe Builder (Tart)</h1>
        <a
          class="shadow bg-blue-500 leading-none px-4 py-2 rounded text-white text-sm hover:bg-blue-600"
          href="https://github.com/cirruslabs/tart"
          target="_blank"
          >docs</a
        >
      </div>
      <form class="px-6" @submit.prevent>
        <label class="block mt-4">
          <span class="text-gray-700">VM Name</span>
          <span class="block text-gray-600 text-sm"
            >Name of the output virtual machine</span
          >
          <input
            autofocus
            class="block border border-gray-300 rounded mt-1 w-full px-3 py-2"
            v-model="vmName"
            type="text"
          />
        </label>
        <label class="block mt-4">
          <span class="text-gray-700">IPSW URL</span>
          <span class="block text-gray-600 text-sm"
            >URL to macOS Tahoe IPSW restore image</span
          >
          <input
            class="block border border-gray-300 rounded mt-1 w-full px-3 py-2"
            v-model="ipswUrl"
            type="text"
            placeholder="https://updates.cdn-apple.com/..."
          />
        </label>
        <label class="block mt-4">
          <span class="text-gray-700">CPU Count</span>
          <span class="block text-gray-600 text-sm"
            >Number of CPU cores to allocate</span
          >
          <input
            class="block border border-gray-300 rounded mt-1 w-full px-3 py-2"
            v-model.number="cpuCount"
            type="number"
            min="1"
          />
        </label>
        <label class="block mt-4">
          <span class="text-gray-700">Memory (GB)</span>
          <span class="block text-gray-600 text-sm"
            >Amount of RAM to allocate</span
          >
          <input
            class="block border border-gray-300 rounded mt-1 w-full px-3 py-2"
            v-model.number="memoryGb"
            type="number"
            min="1"
          />
        </label>
        <label class="block mt-4">
          <span class="text-gray-700">Disk Size (GB)</span>
          <span class="block text-gray-600 text-sm"
            >Size of the virtual disk</span
          >
          <input
            class="block border border-gray-300 rounded mt-1 w-full px-3 py-2"
            v-model.number="diskSizeGb"
            type="number"
            min="20"
          />
        </label>
        <label class="block mt-4">
          <span class="text-gray-700">SSH Username</span>
          <span class="block text-gray-600 text-sm"
            >Username for SSH access</span
          >
          <input
            class="block border border-gray-300 rounded mt-1 w-full px-3 py-2"
            v-model="sshUsername"
            type="text"
          />
        </label>
        <label class="block mt-4">
          <span class="text-gray-700">SSH Password</span>
          <span class="block text-gray-600 text-sm"
            >Password for SSH access</span
          >
          <input
            class="block border border-gray-300 rounded mt-1 w-full px-3 py-2"
            v-model="sshPassword"
            type="password"
          />
        </label>
        <label class="block mt-4">
          <span class="text-gray-700">SSH Timeout</span>
          <span class="block text-gray-600 text-sm"
            >SSH connection timeout (e.g., 180s)</span
          >
          <input
            class="block border border-gray-300 rounded mt-1 w-full px-3 py-2"
            v-model="sshTimeout"
            type="text"
          />
        </label>
        <label class="block mt-4">
          <span class="text-gray-700">Recovery Partition</span>
          <span class="block text-gray-600 text-sm"
            >Keep or remove recovery partition</span
          >
          <select class="block border border-gray-300 rounded mt-1 w-full px-3 py-2" v-model="recoveryPartition">
            <option>keep</option>
            <option>remove</option>
          </select>
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
          template.pkr.hcl
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
      <div class="text-gray-700 whitespace-pre-wrap" id="template">{{ templateHcl }}</div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'

const indent = ref(2)
const vmName = ref('tahoe-vanilla')
const ipswUrl = ref('https://updates.cdn-apple.com/2025FallFCS/fullrestores/089-04148/791B6F00-A30B-4EB0-B2E3-257167F7715B/UniversalMac_26.1_25B78_Restore.ipsw')
const cpuCount = ref(4)
const memoryGb = ref(8)
const diskSizeGb = ref(50)
const sshUsername = ref('admin')
const sshPassword = ref('admin')
const sshTimeout = ref('180s')
const recoveryPartition = ref('keep')

const template = ref({
  _comment: 'Packer template for macOS Tahoe using Tart - Generated by Punk',
  source: {}
})

const templateHcl = computed(() => {
  const indent_str = ' '.repeat(indent.value)
  let hcl = 'packer {\n'
  hcl += indent_str + 'required_plugins {\n'
  hcl += indent_str + indent_str + 'tart = {\n'
  hcl += indent_str + indent_str + indent_str + 'version = ">= 1.12.0"\n'
  hcl += indent_str + indent_str + indent_str + 'source  = "github.com/cirruslabs/tart"\n'
  hcl += indent_str + indent_str + '}\n'
  hcl += indent_str + '}\n'
  hcl += '}\n\n'
  hcl += 'source "tart-cli" "tart" {\n'
  hcl += indent_str + 'from_ipsw    = "' + ipswUrl.value + '"\n'
  hcl += indent_str + 'vm_name      = "' + vmName.value + '"\n'
  hcl += indent_str + 'cpu_count    = ' + cpuCount.value + '\n'
  hcl += indent_str + 'memory_gb    = ' + memoryGb.value + '\n'
  hcl += indent_str + 'disk_size_gb = ' + diskSizeGb.value + '\n'
  hcl += indent_str + 'ssh_password = "' + sshPassword.value + '"\n'
  hcl += indent_str + 'ssh_username = "' + sshUsername.value + '"\n'
  hcl += indent_str + 'ssh_timeout  = "' + sshTimeout.value + '"\n'
  hcl += indent_str + 'recovery_partition = "' + recoveryPartition.value + '"\n'
  hcl += indent_str + 'boot_command = [\n'
  hcl += indent_str + indent_str + '# hello, hola, bonjour, etc.\n'
  hcl += indent_str + indent_str + '"<wait60s><spacebar>",\n'
  hcl += indent_str + indent_str + '# Language selection\n'
  hcl += indent_str + indent_str + '"<wait30s>italiano<esc>english<enter>",\n'
  hcl += indent_str + indent_str + '# Select Your Country or Region\n'
  hcl += indent_str + indent_str + '"<wait60s>united states<leftShiftOn><tab><leftShiftOff><spacebar>",\n'
  hcl += indent_str + indent_str + '# Transfer Your Data to This Mac\n'
  hcl += indent_str + indent_str + '"<wait10s><tab><tab><tab><spacebar><tab><tab><spacebar>",\n'
  hcl += indent_str + indent_str + '# Written and Spoken Languages\n'
  hcl += indent_str + indent_str + '"<wait10s><leftShiftOn><tab><leftShiftOff><spacebar>",\n'
  hcl += indent_str + indent_str + '# Accessibility\n'
  hcl += indent_str + indent_str + '"<wait10s><leftShiftOn><tab><leftShiftOff><spacebar>",\n'
  hcl += indent_str + indent_str + '# Data & Privacy\n'
  hcl += indent_str + indent_str + '"<wait10s><leftShiftOn><tab><leftShiftOff><spacebar>",\n'
  hcl += indent_str + indent_str + '# Create a Mac Account\n'
  hcl += indent_str + indent_str + '"<wait10s><tab><tab><tab><tab><tab><tab>Managed via Tart<tab>admin<tab>admin<tab>admin<tab><tab><spacebar><tab><tab><spacebar>",\n'
  hcl += indent_str + indent_str + '# Enable Voice Over\n'
  hcl += indent_str + indent_str + '"<wait120s><leftAltOn><f5><leftAltOff>",\n'
  hcl += indent_str + indent_str + '# Sign In with Your Apple ID\n'
  hcl += indent_str + indent_str + '"<wait10s><leftShiftOn><tab><leftShiftOff><spacebar>",\n'
  hcl += indent_str + indent_str + '# Are you sure you want to skip signing in with an Apple ID?\n'
  hcl += indent_str + indent_str + '"<wait10s><tab><spacebar>",\n'
  hcl += indent_str + indent_str + '# Terms and Conditions\n'
  hcl += indent_str + indent_str + '"<wait10s><leftShiftOn><tab><leftShiftOff><spacebar>",\n'
  hcl += indent_str + indent_str + '# I have read and agree to the macOS Software License Agreement\n'
  hcl += indent_str + indent_str + '"<wait10s><tab><spacebar>",\n'
  hcl += indent_str + indent_str + '# Enable Location Services\n'
  hcl += indent_str + indent_str + '"<wait10s><leftShiftOn><tab><leftShiftOff><spacebar>",\n'
  hcl += indent_str + indent_str + '# Are you sure you don\'t want to use Location Services?\n'
  hcl += indent_str + indent_str + '"<wait10s><tab><spacebar>",\n'
  hcl += indent_str + indent_str + '# Select Your Time Zone\n'
  hcl += indent_str + indent_str + '"<wait10s><tab><tab><tab>UTC<enter><leftShiftOn><tab><leftShiftOff><spacebar>",\n'
  hcl += indent_str + indent_str + '# Analytics\n'
  hcl += indent_str + indent_str + '"<wait10s><leftShiftOn><tab><leftShiftOff><spacebar>",\n'
  hcl += indent_str + indent_str + '# Screen Time\n'
  hcl += indent_str + indent_str + '"<wait10s><tab><tab><spacebar>",\n'
  hcl += indent_str + indent_str + '# Siri\n'
  hcl += indent_str + indent_str + '"<wait10s><tab><spacebar><leftShiftOn><tab><leftShiftOff><spacebar>",\n'
  hcl += indent_str + indent_str + '# Choose Your Look\n'
  hcl += indent_str + indent_str + '"<wait10s><leftShiftOn><tab><leftShiftOff><spacebar>",\n'
  hcl += indent_str + indent_str + '# Update Mac Automatically\n'
  hcl += indent_str + indent_str + '"<wait10s><tab><tab><spacebar>",\n'
  hcl += indent_str + indent_str + '# Welcome to Mac\n'
  hcl += indent_str + indent_str + '"<wait30s><spacebar>",\n'
  hcl += indent_str + indent_str + '# Disable Voice Over\n'
  hcl += indent_str + indent_str + '"<wait10s><leftAltOn><f5><leftAltOff>",\n'
  hcl += indent_str + indent_str + '# Enable Keyboard navigation\n'
  hcl += indent_str + indent_str + '"<wait10s><leftAltOn><spacebar><leftAltOff>Terminal<wait10s><enter>",\n'
  hcl += indent_str + indent_str + '"<wait10s><wait10s>defaults write NSGlobalDomain AppleKeyboardUIMode -int 3<enter>",\n'
  hcl += indent_str + indent_str + '# Open System Settings\n'
  hcl += indent_str + indent_str + '"<wait10s>open \'/System/Applications/System Settings.app\'<enter>",\n'
  hcl += indent_str + indent_str + '# Navigate to Sharing\n'
  hcl += indent_str + indent_str + '"<wait10s><leftCtrlOn><f2><leftCtrlOff><right><right><right><down>Sharing<enter>",\n'
  hcl += indent_str + indent_str + '# Enable Screen Sharing\n'
  hcl += indent_str + indent_str + '"<wait10s><tab><tab><tab><tab><tab><spacebar>",\n'
  hcl += indent_str + indent_str + '# Enable Remote Login\n'
  hcl += indent_str + indent_str + '"<wait10s><tab><tab><tab><tab><tab><tab><tab><tab><tab><tab><tab><tab><spacebar>",\n'
  hcl += indent_str + indent_str + '# Quit System Settings\n'
  hcl += indent_str + indent_str + '"<wait10s><leftAltOn>q<leftAltOff>",\n'
  hcl += indent_str + indent_str + '# Disable Gatekeeper\n'
  hcl += indent_str + indent_str + '"<wait10s>sudo spctl --global-disable<enter>",\n'
  hcl += indent_str + indent_str + '"<wait10s>admin<enter>",\n'
  hcl += indent_str + ']\n'
  hcl += '}\n\n'
  hcl += 'build {\n'
  hcl += indent_str + 'sources = ["source.tart-cli.tart"]\n'
  hcl += '}\n'

  return hcl
})

const clear = () => {
  vmName.value = 'tahoe-vanilla'
  ipswUrl.value = 'https://updates.cdn-apple.com/2025FallFCS/fullrestores/089-04148/791B6F00-A30B-4EB0-B2E3-257167F7715B/UniversalMac_26.1_25B78_Restore.ipsw'
  cpuCount.value = 4
  memoryGb.value = 8
  diskSizeGb.value = 50
  sshUsername.value = 'admin'
  sshPassword.value = 'admin'
  sshTimeout.value = '180s'
  recoveryPartition.value = 'keep'
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
  // Template is auto-generated via computed property
  // Just scroll to the template view
  const templateEl = document.getElementById('template')
  if (templateEl) {
    templateEl.scrollIntoView({ behavior: 'smooth', block: 'start' })
  }
}
</script>
