import { generateText } from 'ai';
const result = await generateText({
  model: 'google/gemini-2.5-flash-image',
  prompt: 'Generate an image: a small black circle on a white background, flat vector style, no text.',
});
console.log('text:', result.text);
console.log('files:', result.files?.length, result.files?.map(f => ({mediaType: f.mediaType, len: f.base64?.length ?? f.uint8Array?.length})));
if (result.files?.length) {
  const f = result.files[0];
  const bytes = Buffer.from(f.base64 ?? f.uint8Array, f.base64 ? 'base64' : undefined);
  require('fs').writeFileSync('/tmp/gemini-test-circle.png', bytes);
  console.log('saved', bytes.length, 'bytes');
}
