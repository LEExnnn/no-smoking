from langchain_core.prompts import PromptTemplate
from app.services.profile_engine import get_llm

class CravingEngine:
    def __init__(self):
        self.llm = get_llm()
        
        # 针对烟瘾发作时的 5 句短句生成 Prompt
        # 要求：短小精悍，不带羞辱，直接给出动作，针对用户的痛点
        self.prompt = PromptTemplate.from_template("""
你是一个顶级的戒烟心理教练，你的用户现在烟瘾发作了，非常想抽烟。
你需要生成 5 句非常简短的安抚和引导短句。

用户当前的触发场景是：{trigger}
用户的戒烟核心动力是：{motivation}
用户的最大风险场景是：{risk}
用户的错误信念是：{belief}

要求：
1. 必须严格输出 5 句话，每句话用换行符分隔。
2. 不要输出任何标点符号列表（如 1. 2.），直接输出句子本身。
3. 语气要像一个懂他的朋友，**绝对不要说教、不要恐吓、不要羞辱**。
4. 前两句要直接点破他当下的心理需求（例如：“你不是想抽烟，你只是工作累了想休息”）。
5. 中间两句要瓦解他的错误信念。
6. 最后一句要给出明确的行动指令（例如：“闭上眼，深呼吸 5 次”，“现在去倒杯水”）。
7. 每句话不要超过 20 个字。

输出示例：
你现在不是需要烟。
你是想从工作状态里出来。
但"出去"对你来说就是抽烟动线。
这次别下楼。
我陪你深呼吸 90 秒。
""")

    def generate_sos_messages(self, trigger: str, motivation: str, risk: str, belief: str) -> list[str]:
        chain = self.prompt | self.llm
        try:
            result = chain.invoke({
                "trigger": trigger,
                "motivation": motivation,
                "risk": risk,
                "belief": belief
            })
            content = result.content.strip()
            # 分割并清理空行
            messages = [msg.strip() for msg in content.split('\n') if msg.strip()]
            
            # 如果 AI 没有按要求输出 5 句，或者出错，给出备用默认话术
            if len(messages) < 3:
                return self._get_fallback_messages(trigger)
                
            return messages[:5]
        except Exception as e:
            print(f"SOS Engine Error: {e}")
            return self._get_fallback_messages(trigger)

    def _get_fallback_messages(self, trigger: str) -> list[str]:
        # 默认兜底话术
        return [
            "我知道你现在很难受。",
            "深呼吸，承认这份渴望。",
            "你想要的不是烟，而是片刻的放松。",
            "这股冲动只要 90 秒就会过去。",
            "跟我一起，闭上眼睛。"
        ]

engine = CravingEngine()
