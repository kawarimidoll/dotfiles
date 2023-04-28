function ensureValue(value) {
  return ["show", "hover", "hide"].includes(value) ? value : "show";
}

chrome.storage.local.get("Blueswing", (items) => {
  console.log(items, JSON.stringify(items));
  alert('loaded')
});
