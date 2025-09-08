require('dotenv').config();
const { OpenAI } = require('openai');

const openai = new OpenAI({ apiKey: process.env.OPENAI_API_KEY });

async function getMutationsFromPrompt(prompt, model = 'gpt-4o') {
  const response = await openai.chat.completions.create({
    model,
    messages: [
      {
        role: 'system',
        content: 'You are an expert Apex engineer. You generate destructive mutations to evaluate the robustness of test classes. Output format must strictly follow the YAML mutation template.',
      },
      {
        role: 'user',
        content: prompt
      }
    ],
    temperature: 0.2,
    max_tokens: 4096
  });

  const output = response.choices[0].message.content;
  return output;
}

module.exports = {
  getMutationsFromPrompt
};
