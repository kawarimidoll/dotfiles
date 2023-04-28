const visibilities = ["show", "hover", "hide"];
const names = [
  "replys",
  "reposts",
  "likes",
  "followers",
  "following",
  "posts",
];

function ensureValue(value) {
  return visibilities.includes(value) ? value : "show";
}

function setClass(name, value) {
  visibilities.forEach((visibilitiy) => {
    document.body.classList.remove(`${name}-${visibilitiy}`);
  });
  document.body.classList.add(`${name}-${value}`);
}

function setClasses() {
  chrome.storage.local.get(names, (data) => {
    console.log(data);
    names.forEach((name) => {
      setClass(name, ensureValue(data[name]));
    });
  });
}
setClasses();

// function setClasses() {
//   chrome.storage.local.get(names, (data) => {
//     console.log(data);
//     names.forEach((name) => {
//       visibilities.forEach((visibilitiy) => {
//         document.body.classList.remove(`${visibilitiy}-${name}`);
//       });
//       document.body.classList.add(`${ensureValue(data[name])}-${name}`);
//     });
//   });
// }
