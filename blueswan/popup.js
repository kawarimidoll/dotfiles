const names = [
  "replys",
  "reposts",
  "likes",
  "followings",
  "followers",
];

function ensureValue(value) {
  return ["show", "hover", "hide"].includes(value) ? value : "show";
}

console.log("ho");
function load() {
  console.log("hi");
  chrome.storage.local.get("blueswan", (data) => {
    console.log(data);
    // const values = items.blueswan;
    // names.forEach((name) => {
    //   document.getElementByName(name).value = ensureValue(values[name]);
    // });
  });
}


function save() {
  const values = {};
  names.forEach((name) => {
    values[name] = ensureValue(
      [...document.getElementsByName(name)]?.find((element) => element.checked)
        ?.value,
    );
  });

  chrome.storage.local.set({ "blueswan": values }, function () { });

  document.getElementById("save").innerText = "saved";
}

document.getElementById("save").addEventListener("click", save);
load()
