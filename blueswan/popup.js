const names = [
  "replys",
  "reposts",
  "likes",
  "followers",
  "following",
  "posts",
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
        // body.classList.add(`${ensureValue(data[name])}-${name}`);

        chrome.storage.local.set(
          { [name]: event.target.value },
          function () {},
        );
      });
    });
  });
}

load();
