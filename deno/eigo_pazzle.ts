import { sample } from "jsr:@std/collections";

const pronoun_list = [
  ["I", "私"],
  ["You", "あなた"],
  ["He", "彼"],
  ["She", "彼女"],
  ["We", "私たち"],
  ["They", "彼ら"],
];
const tense_list = [
  "普段",
  "今",
  "過去",
  "未来",
];
const verb_list = [
  ["go home", "帰る"],
  ["go to work", "会社に行く"],
  ["go to the gym", "ジムに行く"],
  ["get a haircut", "髪を切る"],
  ["get money out", "お金を下ろす"],
  ["get up", "起きる"],
  ["go to bed", "寝る"],
  ["get to sleep", "寝付く"],
  ["stay home", "家にこもる"],
  ["order in", "出前を取る"],
  ["watch TV", "テレビを観る"],
  ["get ready", "準備する"],
  ["get changed", "着替える"],
  ["spend money", "お金を使う"],
  ["get promoted", "昇格する"],
  ["get transferred", "異動になる"],
  ["get fired", "クビになる"],
  ["meet the deadline", "締切に間に合う"],
  ["hit my target", "目標達成する"],
  ["do overtime", "残業する"],
  ["get paid", "給料をもらう"],
  ["get in trouble", "怒られる"],
  ["ask someone out", "告白する"],
  ["go out (with ~)", "付き合う"],
  ["break up", "別れる"],
  ["get back together", "よりを戻す"],
  ["see a movie", "映画を観る"],
  ["get a video", "ビデオを借りる"],
  ["go drinking", "飲みに行く"],
  ["go shopping", "買い物する"],
  ["go skiing", "スキーに行く"],
  ["eat out", "外食する"],
  ["go to the beach", "海へ行く"],
  ["clean the house", "家の掃除をする"],
  ["make dinner", "夕飯をつくる"],
  ["do the dishes", "皿洗いする"],
  ["do the laundry", "洗濯する"],
];

console.log(
  `${sample(pronoun_list)[1]}は${sample(tense_list)}、${sample(verb_list)[1]}`,
);
