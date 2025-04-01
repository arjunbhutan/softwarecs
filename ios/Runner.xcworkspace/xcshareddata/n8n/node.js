import OpenAI from "openai";

const openai = new OpenAI({
  apiKey: "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",
});

const completion = openai.chat.completions.create({
  model: "gpt-4o-mini",
  store: true,
  messages: [
    {"role": "user", "content": "write a haiku about ai"},
  ],
});

completion.then((result) => console.log(result.choices[0].message));