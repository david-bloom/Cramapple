import { experimental_generateImage as generateImage } from 'ai';
try {
  await generateImage({ model: 'google/gemini-2.5-flash-image', prompt: 'a small black circle on white background', n: 1 });
} catch (err) {
  console.log('message:', err.message);
  console.log('cause:', err.cause);
  if (err.cause?.responseBody) console.log('body:', err.cause.responseBody);
}
