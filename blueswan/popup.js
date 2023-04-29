const names = [
  "replys",
  "reposts",
  "likes",
  "followers",
  "following",
  "posts",
  "blueswan",
];

function ensureValue(value) {
  return ["show", "hover", "hide"].includes(value) ? value : "show";
}

function load() {
  chrome.storage.local.get(names, (data) => {
    names.forEach((name) => {
      const select = document.getElementById(`select-${name}`);
      [...select.options].forEach((option) =>
        option.selected = option.value === ensureValue(data[name])
      );
      select.addEventListener("change", (event) => {
        const { value } = event.target;
        chrome.storage.local.set({ [name]: value }, () => ({}));

        chrome.tabs.query({ active: true, currentWindow: true }, (tabs) => {
          console.log({ tabs });
          const tabId = tabs[0]?.id;
          if (tabId) {
            chrome.tabs.sendMessage(tabId, { name, value }, () => ({}));
          }
        });
      });
    });
  });
}

load();
