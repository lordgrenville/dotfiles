from IPython.terminal.prompts import Prompts, Token
from datetime import datetime

# add current time to in prompt to estimate runtime for long programs

class MyPrompt(Prompts):
     def in_prompt_tokens(self, cli=None):
         return [(Token.Prompt, datetime.strftime(datetime.now(), '%H:%M')),
                 (Token.Prompt, ' '),
                 (Token.Prompt, 'In ['),
                 (Token.PromptNum, str(self.shell.execution_count)),
                 (Token.Prompt, ']: ')]

ip = get_ipython()
ip.prompts = MyPrompt(ip)
