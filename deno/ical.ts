import { DOMParser, Element } from "jsr:@b-fuze/deno-dom";

function sleep(seconds: number) {
  return new Promise((resolve) => setTimeout(resolve, seconds * 1000));
}

function formatDate(date: Date) {
  return `${String(date.getFullYear()).padStart(4, "0")}${
    String(date.getMonth() + 1).padStart(2, "0")
  }${String(date.getDate()).padStart(2, "0")}`;
}

const RETRY_LIMIT = 3;
const RETRY_WAIT = 5;
async function fetchPage(url: string) {
  // fetch API
  // if error occurs, retry up to 3 times after 5 seconds
  // if successful, return the response

  for (let i = 0; i <= RETRY_LIMIT; i++) {
    try {
      return await fetch(url);
    } catch (error) {
      console.log(error);
      if (i < RETRY_LIMIT) {
        console.log(
          `Retry ${i + 1}/${RETRY_LIMIT} after ${RETRY_WAIT} seconds...`,
        );
        await sleep(RETRY_WAIT);
      }
    }
  }
  console.log(`Retry failed`);
  return null;
}

const locations = [
  "Melbourne",
  "Mount Dandenong",
  "Sunbury",
  "Melton",
  "Laverton",
  "Tullamarine",
  "Yarra Glen",
  "Watsonia",
  "Scoresby",
  "Moorabbin",
  "Frankston",
  "Dandenong",
  "Cranbourne",
  "Pakenham",
];

const location = locations[0].replace(/ /g, "").toLowerCase();

const url = `http://www.bom.gov.au/vic/forecasts/${location}.shtml`;

const ical = `BEGIN:VCALENDAR
PRODID:BOM weather - iCal weather
VERSION:2.0
METHOD:PUBLISH
CALSCALE:GREGORIAN
X-WR-CALNAME:iCal Weather in week (${location})
X-WR-CALDESC:iCal formatted BOM Forecast
X-WR-TIMEZONE:Australia/Melbourne
##VEVENT##
BEGIN:VTIMEZONE
TZID:Australia/Melbourne
BEGIN:STANDARD
DTSTART:19700101T000000
TZOFFSETFROM:+1000
TZOFFSETTO:+1000
END:STANDARD
END:VTIMEZONE
END:VCALENDAR`;

const response = await fetchPage(url);

if (!response) {
  console.log("Failed to fetch weather");
  Deno.exit(1);
}

const html = await response.text();
const doc = new DOMParser().parseFromString(html, "text/html")!;
const forecasts = doc.querySelectorAll("#content > div.day")!;

const list = [];
const date = new Date();
date.setDate(date.getDate() + 1);

// const weathers = ["☀", "⛅", "🌧"];

for (const forecast of forecasts) {
  // const weather = weathers[Math.floor(Math.random() * weathers.length)];
  // const title = `Weather ${weather}`;
  const summary = forecast.querySelector(".summary").textContent;

  const pop = forecast.querySelector(".pop").textContent.replace(/\s/g, "");

  const min = forecast.querySelector(".min")?.textContent ?? "";
  const max = forecast.querySelector(".max")?.textContent ?? "";
  const temperature = min && max ? ` ${max} / ${min}` : "";

  const description = forecast.querySelector("p").textContent;

  const currentDate = formatDate(date);
  date.setDate(date.getDate() + 1);
  const nextDate = formatDate(date);

  const vEvent = `BEGIN:VEVENT
UID:kawarimidoll/forecast/ical/${location}/${currentDate}
DESCRIPTION:${description}
DTSTART:${currentDate}
DTEND:${nextDate}
SUMMARY:${summary}${temperature} ${pop}
END:VEVENT`;

  list.push(vEvent);
}

console.log(ical.replace("##VEVENT##", list.join("\n")));
