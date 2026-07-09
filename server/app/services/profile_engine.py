import json
from typing import Dict, Any, List
from langchain_openai import ChatOpenAI
from langchain_core.prompts import PromptTemplate
from langchain_core.output_parsers import JsonOutputParser
from app.core.config import settings
from app.schemas.profile import QuestionnaireSubmit

def get_llm():
    return ChatOpenAI(
        api_key=settings.DEEPSEEK_API_KEY,
        base_url=settings.DEEPSEEK_API_BASE,
        model="deepseek-chat",  # DeepSeek 的对话模型
        temperature=0.3, # 偏稳定输出
    )

class ProfileEngine:
    def __init__(self):
        self.llm = get_llm()

    async def generate_profile_data(self, answers: QuestionnaireSubmit) -> Dict[str, Any]:
        """
        利用大模型分析用户问卷，生成个性化的戒烟画像权重。
        """
        
        prompt_template = """
        你是一个专业的戒烟心理辅导专家。你需要分析用户填写的戒烟心理问卷，并生成标准化的 JSON 数据供系统调度使用。
        
        用户的问卷答案如下：
        {answers}
        
        请严格按照以下 JSON 格式输出你的分析结果，不要包含任何额外的说明文字：
        {{
            "smoking_years": 整数（根据年龄推算，如果是初中大概是10年以上，如果不好判断默认5）,
            "cigarettes_per_day": 浮点数（根据选项如"1-5支"取平均3）,
            "pack_price": 浮点数（根据选项如"15-25"取20）,
            "dependence_level": "low" | "medium" | "mediumHigh" | "high",
            "user_types": ["字符串数组，例如：工作休息触发型、社交需求型、情绪依赖型"],
            "motivation_weights": {{"字典格式，键必须是 health, money, baby, partner, parents, freedom, control 等，值是 0.0 到 1.0 之间的权重，总和不必为1"}},
            "trigger_weights": {{"字典格式，键必须是 wakeUp, afterMeal, workTired, stress, bored 等场景英文缩写，值是 0.0 到 1.0 的权重"}},
            "belief_tags": ["字符串数组，用户存在的错误信念标签，例如：放松幻觉、奖励幻觉、无聊补偿"],
            "recommended_modules": ["字符串数组，系统推荐开启的功能，只能从这些里面选：ai_rescue, money_bank, baby_account, work_mode, relapse_repair, cognitive_course"]
        }}
        """
        
        prompt = PromptTemplate(
            template=prompt_template,
            input_variables=["answers"],
        )
        
        # 将 Pydantic 对象转为美化的 JSON 字符串供 LLM 读取
        answers_str = json.dumps(answers.model_dump(), ensure_ascii=False, indent=2)
        
        parser = JsonOutputParser()
        chain = prompt | self.llm | parser
        
        result = await chain.ainvoke({"answers": answers_str})
        return result
