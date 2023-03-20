import whisper
import gradio as gr
import openai
from TTS.api import TTS

# Install packages if needed
# !pip install openai-whisper
# !pip install gradio
# !pip install openai

def initialize_tts():
    model_name = TTS.list_models()[9]
    tts = TTS(model_name)
    return tts

def initialize_whisper():
    model = whisper.load_model("medium")
    return model

def setup_openai_api_key():
    openai.api_key = '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'

def voice_chat(user_voice):
    messages = [
        {"role": "system", "content": "You are a kind helpful assistant who is knowledgeable about cosmetics products."},
    ]

    user_message = model.transcribe(user_voice)["text"]

    messages.append(
        {"role": "user", "content": user_message},
    )

    chat = openai.ChatCompletion.create(
        model="gpt-3.5-turbo", messages=messages
    )

    reply = chat.choices[0].message.content

    messages.append({"role": "assistant", "content": reply})

    tts.tts_to_file(text=reply, file_path="output.wav")

    return reply, 'output.wav'


if __name__ == '__main__':
    tts = initialize_tts()
    model = initialize_whisper()
    setup_openai_api_key()

    text_reply = gr.Textbox(label="ChatGPT Text")
    voice_reply = gr.Audio('output.wav')

    gr.Interface(
        title='AI Voice Assistant with ChatGPT AI',
        fn=voice_chat,
        inputs=[
            gr.inputs.Audio(source="microphone", type="filepath")
        ],
        outputs=[
            text_reply, voice_reply
        ], live=True).launch(share=True)
